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

#!/bin/bash

# MARK: - Swift

if ! command -v swift &> /dev/null; then
    echo "It looks like you might not have Swift installed in your system."
    echo "You can install Swift by visiting https://www.swift.org/install"
    exit 1
else
    echo "✅ Swift is installed!"
fi

# MARK: - Homebrew

if ! command -v brew &> /dev/null; then
    echo "🛠️ Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ Installed Homebrew!"
else
    echo "✅ Homebrew is installed!"
fi

# MARK: - SwiftLint

if ! command -v swiftlint &> /dev/null; then
    echo "🛠️ Installing SwiftLint..."
    brew install swiftlint
    echo "✅ SwiftLint installed!"
else
    echo "✅ SwiftLint is installed!"
fi

# MARK: - Hooks

echo "🪝 Setting up local git hooks..."
PROJECT_DIR="$(git rev-parse --show-toplevel)"
git config --local core.hooksPath "${PROJECT_DIR}/Scripts/Hooks/"
chmod u+x "${PROJECT_DIR}/Scripts/Hooks/pre-commit"
chmod u+x "${PROJECT_DIR}/Scripts/Hooks/commit-msg"
echo "✅ Local git hooks setup."
