<!-- template:define:options
{
  "nodescription": true
}
-->
![logo](https://liam.sh/-/gh/svg/lrstanley/corpse?layout=left&icon=fluent-emoji-flat%3Amagic-wand&icon.width=60&bg=geometric)

<!-- template:begin:header -->
<!-- do not edit anything in this "template" block, its auto-generated -->

<p align="center">
  <a href="https://github.com/lrstanley/corpse/tags">
    <img title="Latest Semver Tag" src="https://img.shields.io/github/v/tag/lrstanley/corpse?style=flat-square">
  </a>
  <a href="https://github.com/lrstanley/corpse/commits/master">
    <img title="Last commit" src="https://img.shields.io/github/last-commit/lrstanley/corpse?style=flat-square">
  </a>


  <a href="https://github.com/lrstanley/corpse/actions?query=workflow%3Atest+event%3Apush">
    <img title="GitHub Workflow Status (test @ master)" src="https://img.shields.io/github/actions/workflow/status/lrstanley/corpse/test.yml?branch=master&label=test&style=flat-square">
  </a>

  <a href="https://codecov.io/gh/lrstanley/corpse">
    <img title="Code Coverage" src="https://img.shields.io/codecov/c/github/lrstanley/corpse/master?style=flat-square">
  </a>

  <a href="https://pkg.go.dev/github.com/lrstanley/corpse">
    <img title="Go Documentation" src="https://pkg.go.dev/badge/github.com/lrstanley/corpse?style=flat-square">
  </a>
  <a href="https://goreportcard.com/report/github.com/lrstanley/corpse">
    <img title="Go Report Card" src="https://goreportcard.com/badge/github.com/lrstanley/corpse?style=flat-square">
  </a>
</p>
<p align="center">
  <a href="https://github.com/lrstanley/corpse/issues?q=is:open+is:issue+label:bug">
    <img title="Bug reports" src="https://img.shields.io/github/issues/lrstanley/corpse/bug?label=issues&style=flat-square">
  </a>
  <a href="https://github.com/lrstanley/corpse/issues?q=is:open+is:issue+label:enhancement">
    <img title="Feature requests" src="https://img.shields.io/github/issues/lrstanley/corpse/enhancement?label=feature%20requests&style=flat-square">
  </a>
  <a href="https://github.com/lrstanley/corpse/pulls">
    <img title="Open Pull Requests" src="https://img.shields.io/github/issues-pr/lrstanley/corpse?label=prs&style=flat-square">
  </a>
  <a href="https://github.com/lrstanley/corpse/discussions/new?category=q-a">
    <img title="Ask a Question" src="https://img.shields.io/badge/support-ask_a_question!-blue?style=flat-square">
  </a>
  <a href="https://liam.sh/chat"><img src="https://img.shields.io/badge/discord-bytecord-blue.svg?style=flat-square" title="Discord Chat"></a>
</p>
<!-- template:end:header -->

<!-- template:begin:toc -->
<!-- do not edit anything in this "template" block, its auto-generated -->
## :link: Table of Contents

  - [Features](#sparkles-features)
  - [Usage](#gear-usage)
  - [References](#books-references)
  - [Support &amp; Assistance](#raising_hand_man-support--assistance)
  - [Contributing](#handshake-contributing)
  - [License](#balance_scale-license)
<!-- template:end:toc -->

## :sparkles: Features

- **Text Vectorization**: Convert text documents into numerical vectors using TF-IDF (Term Frequency-Inverse Document Frequency).
- **Term Processing**:
  - Built-in tokenization for text processing.
  - Support for extensible term filtering (stop words, lemmatization, stemming, etc).
  - Configurable term pruning to remove common or rare terms (minimum and maximum document frequency).
- **Vector Management**:
  - Configurable vector size limits.
  - Automatic term frequency tracking.
  - Efficient memory usage with object pooling.
- **Search Capabilities**:
  - Simple integration with HNSW (Hierarchical Navigable Small Worlds) for fast similarity search, and
    other search algorithms.

## :warning: Limitations

- Designed for addition-only vectorization. If you want to remove or update documents, you'll need to
  re-index the entire corpus. This does mean reduced memory usage, however.
- Designed primarily for in-memory vectorization. If you need clustering, or advanced features, use
  a proper vector database (and something like LLM-based embedding).
- I'm not an expert in text embedding, so there may be better ways to do this.

---

## :gear: Usage

```console
$ go get github.com/lrstanley/corpse

# if you want lemmatization or stemming. note that these support english only.
# see the source if you want to use a different language.
$ go get github.com/lrstanley/corpse/lemm
$ go get github.com/lrstanley/corpse/stem
```

```go
package main

import (
    "fmt"
    "github.com/coder/hnsw"
    "github.com/lrstanley/corpse"
    "github.com/lrstanley/corpse/lemm"
    "github.com/lrstanley/corpse/stem"
)

func main() {
    vectorSize := 25

    // Initialize a corpus with custom options.
    corp := corpse.New(
        corpse.WithMaxVectorSize(vectorSize),
        corpse.WithTermFilters(
            lemm.NewTermFilter(), // Add lemmatization.
            stem.NewTermFilter(), // Add stemming.
            corpse.StopTermFilter([]string{ // Remove common stop words.
                "the", "and", "is", "in", "etc...",
            }),
        ),
        corpse.WithPruneHooks(
            // Remove terms that appear in more than 85% of documents.
            corpse.PruneMoreThanPercent(85),
        ),
    )

    // Index your documents
    documents := map[string]string{
        "brown-fox":     "The quick brown fox jumps over the lazy dog.",
        "yellow-fox":    "The slow yellow fox jumps over the fast cat.",
        "foo-bar":       "Foo bar@baz",
        "walking-store": "I was walking to the store. Alphabetically, working, testing, and so on.",
        "lorem-ipsum":   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    }

    for _, doc := range documents {
        corp.IndexDocument(doc)
    }

    // Create a search graph.
    graph := hnsw.NewGraph[string]()
    graph.M = vectorSize // Should match your vector size.

    // Add documents to the graph.
    for id, doc := range documents {
        graph.Add(hnsw.MakeNode(id, corp.CreateVector(doc)))
    }

    // Search for similar documents.
    query := "yellow fox"
    results := graph.Search(corp.CreateVector(query), 2)

    for _, result := range results {
        fmt.Println(result.Key)
    }
}
```

For more advanced examples, check out the [examples directory](examples/).

## :books: References

- [Term Frequency-Inverse Document Frequency (TF-IDF)](https://www.geeksforgeeks.org/understanding-tf-idf-term-frequency-inverse-document-frequency/)
  - https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html
- [Hierarchical Navigable Small Worlds (HNSW)](https://github.com/coder/hnsw)

---

<!-- template:begin:support -->
<!-- do not edit anything in this "template" block, its auto-generated -->
## :raising_hand_man: Support & Assistance

* :heart: Please review the [Code of Conduct](.github/CODE_OF_CONDUCT.md) for
     guidelines on ensuring everyone has the best experience interacting with
     the community.
* :raising_hand_man: Take a look at the [support](.github/SUPPORT.md) document on
     guidelines for tips on how to ask the right questions.
* :lady_beetle: For all features/bugs/issues/questions/etc, [head over here](https://github.com/lrstanley/corpse/issues/new/choose).
<!-- template:end:support -->

<!-- template:begin:contributing -->
<!-- do not edit anything in this "template" block, its auto-generated -->
## :handshake: Contributing

* :heart: Please review the [Code of Conduct](.github/CODE_OF_CONDUCT.md) for guidelines
     on ensuring everyone has the best experience interacting with the
    community.
* :clipboard: Please review the [contributing](.github/CONTRIBUTING.md) doc for submitting
     issues/a guide on submitting pull requests and helping out.
* :old_key: For anything security related, please review this repositories [security policy](https://github.com/lrstanley/corpse/security/policy).
<!-- template:end:contributing -->

<!-- template:begin:license -->
<!-- do not edit anything in this "template" block, its auto-generated -->
## :balance_scale: License

```
MIT License

Copyright (c) 2025 Liam Stanley <liam@liam.sh>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

_Also located [here](LICENSE)_
<!-- template:end:license -->
