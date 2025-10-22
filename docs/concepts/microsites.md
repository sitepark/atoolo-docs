# Microsites

A microsite is a compact, thematically focused website that often serves as a supplement to a main website. It is often used to highlight specific topics such as events, projects, offers or campaigns. Microsites are characterized by their clear structure, targeted content and independent design, which often differs from the main website.

Microsites offer the opportunity to address specific target groups without overloading the main website. They make it possible to present content flexibly and independently of the existing structure of the main website, for example for time-limited projects or special occasions. This allows specific topics to be communicated and highlighted more effectively.

As a rule, microsites adopt the basic design of the main website to ensure visual consistency. At the same time, however, they can be individualized with accents such as adapted colors, logos or other design elements. The design of the homepage or category pages can also differ from the main website in order to meet the specific requirements of the microsite. In addition, the footer can be adapted or completely redesigned to optimally support the content and objectives of the microsite.

## Integration with the main website and other microsites

Although microsites are independent areas, they can also integrate content from the main website or other microsites, for example in the form of links or teasers. In addition, the search can be configured to include pages from the main website or other microsites to ensure a seamless user experience.

### Teaser

Teasers of articles provided by the main website or another microsite are given a customized "kicker". The kicker is used to provide additional context to the content of the teaser, for example by indicating the category. However, if such a teaser is displayed on a microsite, the original kicker often no longer fits the context. Therefore, the teaser's kicker is overwritten and replaced by the name of the main website or the corresponding microsite.

# Microsites

Microsites are websites that belong to a superordinate website, but are outsourced to a separate area for content reasons. Microsites are compact, thematically focused websites that deal exclusively with a specific topic. They are often used to highlight specific topics such as events, projects, offers or campaigns.

Microsites are characterized by their clear structure, targeted content and independent design, which often differs from the main website. At the same time, they generally adopt basic functions and the design of the main website, but can be adapted in selected areas.

## Features of microsites

Microsites have the following characteristic features:

- **Own homepage and navigation**: Microsites have their own homepage and navigation structure.
- **Customizable theming**: Depending on the project-specific implementation, microsites can use other color schemes or design elements.
- **Individual header and footer**: Microsites often have their own header and footer that are different from the main website.
- **Own logo**: Microsites can use their own logo that emphasizes their individuality.
- **Different page structure**: The structure of the homepage and category pages may differ from the main website.
- **Limited or extended range of functions**: Microsites can either offer fewer functions compared to the main website or add specific functions that are only available for the microsite.
- **Common Resource Channel**: Microsites use the same resource channels as the main website.
- **Assignment to the main website**: Each microsite is assigned to a specific main website.
- **Full text search**: Microsites use the full-text index of the main website, but can restrict the search to their own area.
- **Domain options**: Microsites can either be accessible via the domain of the main website (e.g. `/microsite/[name]`) or via their own domain. In the case of a separate domain, a redirect is made from the main website to the microsite domain.

## Integration with the main website and other microsites

Although microsites are independent areas, they can integrate content from the main website or other microsites, for example in the form of links or teasers. In addition, the search can be configured to include pages from the main website or other microsites to ensure a seamless user experience.

### Teaser

Teasers of articles provided by the main website or another microsite are given a customized "kicker". The kicker is used to provide additional context to the content of the teaser, for example by indicating the category. However, if such a teaser is displayed on a microsite, the original kicker often no longer fits the context. Therefore, the teaser's kicker is overwritten and replaced by the name of the main website or the corresponding microsite.

## Microsites with their own domain

If a microsite is operated with its own domain, the following points must be observed:

- **Forwarding**: It must be ensured that the pages can no longer be accessed via the main website, but redirect to the microsite domain.
- **Statistics**: A separate site must be defined for Matomo or other analysis tools in order to record the call statistics for the microsite domain.
- **Domain change for links**: Pages linked from the main website continue to use the domain of the main website. When such a link is clicked, the domain is changed.

### Mount pages of the main website in microsites (microsite mounting)

If the microsite is operated via its own domain, it may be desirable for some of the main website to be displayed via the microsite domain and in the microsite design. There are two options for this:

#### Blanket marking via the article type

Article types can be defined whose articles are always displayed in the appearance of the microsite when they are accessed via the microsite. These pages are added to the navigation directly below the microsite homepage, but are not visible as a menu item. The breadcrumb trail only shows the homepage and the page itself. These pages are not found via the microsite-specific search.

#### Marking by adding to the microsite navigation

Alternatively, articles can be added directly to the microsite navigation. These articles are visible in the navigation and can also be found via the microsite-specific search.
