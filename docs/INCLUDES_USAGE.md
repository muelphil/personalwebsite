# Post Include Components Usage Guide

## Scientific Reference

Use this to cite academic papers, articles, and research at the end of your posts.

### Syntax
```liquid
{% include scientific_reference.html
  shortcut="unique-id"
  authors="Last, F., Last2, F."
  year="2024"
  title="Paper Title Here"
  link="[DOI](https://doi.org/...)"
  note="Optional: Conference or journal info"
%}
```

### Parameters
- **shortcut** (required): Unique ID for the reference (e.g., "smith2020")
- **authors** (required): Author list as string
- **year** (required): Publication year
- **title** (required): Full paper/article title
- **link** (required): Markdown link (will be rendered)
- **note** (optional): Additional context (e.g., conference name)

### Linking to References
In your post text, link to a reference using:
```markdown
Recent work [[shortcut-id]](#ref-shortcut-id) shows that...
```

The `#ref-` prefix is automatically added to create the anchor.

---

## Link Block

Use this to create attractive, clickable cards linking to external resources or other pages.

### Syntax
```liquid
{% include link_block.html
  image="/path/to/image.jpg"
  author="Author Name"
  title="Link Title"
  text="Description of the linked resource"
  url="https://example.com"
%}
```

### Parameters
- **image** (required): Path to thumbnail image
- **author** (optional): Author or source name
- **title** (required): Link title/heading
- **text** (required): Description text
- **url** (required): Target URL

### Example Usage in Posts

```markdown
## Further Reading

{% include link_block.html
  image="/assets/content_compressed/my-image.jpg"
  author="OpenAI"
  title="GPT-4 Technical Report"
  text="Detailed technical documentation about GPT-4's architecture and capabilities."
  url="https://arxiv.org/abs/2303.08774"
%}
```

---

## Complete Example

See `docs/_drafts/2024-04-12-example3.markdown` for a complete working example with both components.
