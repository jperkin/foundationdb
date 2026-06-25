/*
 * IllumosPrelude.h
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
 * Force-included before any other header on illumos targets (see
 * cmake/ConfigureCompiler.cmake).  It must run before anything else can pull
 * in <unistd.h>, which is why it is force-included rather than reached through
 * a normal #include: once <unistd.h>'s guard is set, a later include is inert.
 */

#ifndef FLOW_ILLUMOS_PRELUDE_H
#define FLOW_ILLUMOS_PRELUDE_H

#if defined(__illumos__)

/*
 * Some illumos toolchains incorrectly define __STDC_VERSION__ even when
 * compiling C++.  Headers that gate the C99 `restrict` keyword on it (e.g.
 * xxhash.h) then emit a bare `restrict`, which is not a keyword in C++.
 */
#if defined(__cplusplus) && defined(__STDC_VERSION__)
#undef __STDC_VERSION__
#endif

/*
 * illumos <unistd.h> exposes a legacy SVID `yield(void)` (gated on
 * __EXTENSIONS__, which this build sets globally) that collides with flow's
 * `Future<Void> yield(TaskPriority)`: a no-argument `yield()` is ambiguous
 * between the two.  Redefine the `yield` token before <unistd.h> is parsed so
 * libc's declaration is rewritten to a junk name and never joins the overload
 * set, then undefine the macro so flow's yield is usable normally.  FDB never
 * calls the libc yield().
 */
#define yield __illumos_libc_yield_do_not_use
#include <unistd.h>
#undef yield

#endif /* __illumos__ */

#endif /* FLOW_ILLUMOS_PRELUDE_H */
