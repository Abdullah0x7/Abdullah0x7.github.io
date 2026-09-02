# SEO Audit Checklist — Before/After Comparison

## On-Page SEO

| Metric | Before | After | Status |
|--------|--------|-------|--------|
| Title tag format | Generic `\| ABDULLAH BELLO` | Keyword-first `\| Abdullah Bello` | ✅ |
| Meta descriptions | Partial (some posts missing) | All posts via `description` front matter + jekyll-seo-tag | ✅ |
| H1 per page | One H1 on post cards (home) | Hero H1 on home; post titles as H1 on posts | ✅ |
| Image alt text | Inconsistent | Required pattern documented in style guide | ⚠️ Review per post |
| Internal linking | Minimal | Author bio links to `/about/`; related posts enabled | ✅ |
| Open Graph tags | jekyll-seo-tag basic | og:title, og:description, og:image, og:url via seo-tag + social_preview_image | ✅ |
| Twitter Cards | summary | summary_large_image with social preview | ✅ |
| Canonical URLs | jekyll-seo-tag | Self-referencing on all pages | ✅ |

## Technical SEO

| Metric | Before | After | Status |
|--------|--------|-------|--------|
| Schema.org Person | Inline in default.html | Person + BlogPosting + BreadcrumbList + WebSite | ✅ |
| XML Sitemap | Not present | `/sitemap.xml` with priorities (home 1.0, posts 0.8, archives 0.6) | ✅ |
| robots.txt | Not present | Allow crawl, disallow assets/drafts | ✅ |
| GTM tracking | Mixed G-PMZJMWM3M5 | GTM-WHSWV986 preserved | ✅ |
| Breadcrumb navigation | Visual only | BreadcrumbList JSON-LD on posts | ✅ |
| Tag page SEO | No meta | CollectionPage schema + optimized layout | ✅ |
| URL structure | `/posts/:title/` | Preserved (no broken links) | ✅ |

## Performance Targets

| Metric | Target | Implementation |
|--------|--------|----------------|
| Lighthouse Performance | ≥90 mobile | System fonts, compressed CSS, lazy images |
| LCP | <2.5s | Eager hero avatar, minimal blocking JS |
| CLS | <0.1 | Explicit image width/height on hero |
| FID | <100ms | Deferred PWA/analytics scripts |
| Page load (3G) | <1.5s | No web fonts, static HTML, CDN assets |

## Content SEO Recommendations

- [ ] Add `description` to posts missing it (VPC, Information-Literacy, IoT posts)
- [ ] Add `focus_keyword` as a mental checklist per post (1–2 target phrases)
- [ ] Submit sitemap at [Google Search Console](https://search.google.com/search-console)
- [ ] Validate structured data at [Rich Results Test](https://search.google.com/test/rich-results)
- [ ] Run Lighthouse audit on mobile after deploy

## Validation Steps

1. `bundle exec jekyll build` — confirm zero errors
2. Check all `/posts/*` URLs return 200
3. Validate `/sitemap.xml` in Search Console
4. Test `/robots.txt` allows homepage and posts
5. Run [PageSpeed Insights](https://pagespeed.web.dev/) on homepage and one post
6. Verify GTM-WHSWV986 fires in Tag Assistant
