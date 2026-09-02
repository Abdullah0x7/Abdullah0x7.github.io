# Style Guide — abdullahbello.name.ng

## Design Principles

- **Glassmorphism**: Frosted glass cards with backdrop blur, translucent backgrounds, subtle borders
- **Monochrome + accent**: White/gray/black base with deep indigo (`#4338ca`) accent
- **8px grid**: All spacing uses multiples of 8px (0.5rem at 16px base)
- **Mobile-first**: Design for 375px, scale up to 2560px

## Color Palette

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--accent-color` | `#4338ca` | `#6366f1` | Links, CTAs, tag accents |
| `--glass-bg` | `rgba(255,255,255,0.72)` | `rgba(30,30,35,0.75)` | Card backgrounds |
| `--glass-border` | `rgba(255,255,255,0.45)` | `rgba(255,255,255,0.08)` | Card borders |
| `--heading-color` | `#1a1a2e` | `#e8e8ed` | Headings |
| `--text-color` | `#34343c` | `#afb0b1` | Body text |

## Typography

```scss
font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
```

- **H1**: One per page, 1.5–1.75rem, weight 700
- **Post body**: Max width 42rem (~65 characters)
- **Code**: `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace`

## Spacing Scale

| Token | Value | Pixels |
|-------|-------|--------|
| `$space-1` | 0.5rem | 8px |
| `$space-2` | 1rem | 16px |
| `$space-3` | 1.5rem | 24px |
| `$space-4` | 2rem | 32px |
| `$space-5` | 2.5rem | 40px |
| `$space-6` | 3rem | 48px |

## Components

### Glass Card
Apply `.glass-card` or use the `@include ds.glass-card()` mixin for new components.

### Hero Section
Homepage only. Includes avatar, headline, subtitle, and two CTAs.

### Post Cards
Blog grid cards show title, excerpt, date, categories, and inline tag pills.

### Sidebar Panels
Recent posts and trending tags use glass panels with left accent border.

## Adding New Posts

1. Create file in `_posts/` with format `YYYY-MM-DD-title.md`
2. Include front matter:
   ```yaml
   ---
   title: "Focus Keyword | Descriptive Title"
   description: "150-160 char meta description with action verb."
   date: YYYY-MM-DD HH:MM:SS +0100
   categories: [Cloud-Computing]
   tags: [AWS, Cloud-Computing]
   ---
   ```
3. Use descriptive H2/H3 hierarchy (one H1 comes from layout)
4. Add 3–5 internal links with descriptive anchor text
5. Include alt text on all images

## Accessibility

- Minimum contrast ratio 4.5:1 for body text (WCAG AA)
- All interactive elements keyboard-focusable
- Images require descriptive `alt` attributes
- Use semantic HTML (`<article>`, `<nav>`, `<section>`)

## Performance

- System fonts only (no web font downloads)
- Lazy-load images below the fold
- Keep hero avatar `loading="eager"`, post images lazy
