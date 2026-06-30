/*
 * foundationdb.d
 *
 * This source file is part of the FoundationDB open source project
 *
 * Copyright 2013-2026 Apple Inc. and the FoundationDB project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * USDT provider for the flow run loop and actor lifecycle.  Argument widths
 * must match the C values passed to FDB_TRACE_PROBE().
 */
provider foundationdb {
	probe run_loop_begin();
	probe run_loop_yield();
	probe run_loop_tasks_start(int queue_size);
	probe run_loop_done(int queue_size);
	probe run_loop_ready_timers(int num_timers);
	probe run_loop_thread_ready(int num_ready);
	probe actor_create(const char* name, unsigned long id);
	probe actor_destroy(const char* name, unsigned long id);
	probe actor_enter(const char* name, unsigned long id, int index);
	probe actor_exit(const char* name, unsigned long id, int index);
};
