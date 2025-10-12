module vitrine

import time { sleep }

pub fn create_interval(ms i64, callback fn ()) {
	run := fn [ms, callback] () {
		for {
			sleep(ms * 1000000)
			callback()
		}
	}
	go run()
}
