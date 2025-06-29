---
layout: default
title: Tags
nav: true
permalink: /tags/
---

<h1>All Tags</h1>
<ul>
  {% for tag in site.tags %}
    <li>
      <a href="/tags/{{ tag[0] | uri_escape }}/">#{{ tag[0] }}</a> ({{ tag[1].size }})
    </li>
  {% endfor %}
</ul>
