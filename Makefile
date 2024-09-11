# MIT License
#
# Copyright (c) 2024 Connor Ricks
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

default: test

# MARK: - Building

# Builds VaporRouteBuilder for release.
build-release:
	@$(MAKE) CONFIG=release build

# Builds VaporRouteBuilder for debug.
build-debug:
	@$(MAKE) CONFIG=debug build

# Builds VaporRouteBuilder with the provided config.
#       CONFIG: [release, debug]
build:
	@echo "\n💧 Building VaporRouteBuilder for $(CONFIG)...\n"
	swift build -c $(CONFIG)
	@echo "\n✅ VaporRouteBuilder has been built\n"

# MARK: - Testing

# Runs the unit tests for VaporRouteBuilder.
test:
	@echo "\n🧪 Testing VaporRouteBuilder...\n"
	swift test
	@echo "\n✅ VaporRouteBuilder has been tested\n"
