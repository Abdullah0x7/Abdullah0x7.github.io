---
layout: default
title: Portfolio
permalink: /portfolio/
nav: true
---
# My Projects

- Here are some of my personal and professional projects. Click on any project to view the full walkthrough.

<div class="portfolio-grid">
  {% for project in site.data.projects %}
    <a href="{{ project.url }}" class="portfolio-item">
      <img src="{{ project.image }}" alt="{{ project.title }}">
      <div class="caption">{{ project.title }}</div>
    </a>
  {% endfor %}
</div>
