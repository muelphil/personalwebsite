You are in a project containing a Jekyll Website that is being hosted on GitHub Pages and is used as a personal website.
The website was created a long time ago and is in bad shape when it comes to design and content.
I want to change that by reworking it step by step.

First, here is some information about the structure:
* The page consists of these main pages:
  * /personalwebsite -- home page, containing a header, short introduction, socials, featured project and a reach out remark. The main html page for this is located in /docs/_layouts/home.html
  * /personalwebsite/posts -- overview over all posts, ordered latest to oldest located in _layouts/posts.html
  * /personalwebsite/about -- this should contain my CV and experiences, currently not implemented -- needs to be added later, blank page located in _layouts/about_page.html
  * and the individual blog entry pages such as /personalwebsite/2024/05/13/Bluetooth-on-RPi.html -- main theme contained in _layouts/post.html

To rework the page I first need to figure out the theme/design. I would like to first rework the home page (/docs/_layouts/home.html and layouts/includes that it uses). After that I can adjust all other pages to match the style.
To do so, I would like to first strip the home from the current design, arrange everything in a column layout and apply a very basic simple style. This is to get rid of the old theme before starting working on a new one, focussing the page on it contents, instead of the theme, while maintaining readability. Apply a minimal theme that is readable and uses a basic dark medium contrast color scheme. Remove every other styling. You may adjust the home.html page and the layouts this uses.

The Home Page needs to have the following sections:
* Header: My Name (Philip) left and right the navigation buttons: Blog (formerly Posts), Search, About & Contact
* A short introduction that is text only, for now you can use 3-4 lorem ipsum sentences.
* Social links beneath
* Featured Projects: section with the 2 featured posts
* Recent Blog Posts: section with the 3 most recent blog post entries -- this should not contain any of the 2 featured posts
* A reach out remark

Please strip home.html and used includes from their previous theme. Any new theme settings should go into a separate styling file. We will work on the new theme in subsequent steps.

---

This is okay, but the minimal theme should be more fleshed out. It should be okay to look at - mobile first, limited to a certain width, displayed in the center, reasonable font sizes.
Also, the page is missing the images of the posts, they need to  be included.

---

There should not be multiple background colors. Currently, .home-minimal uses a different theme than the body tag. Please use new classes if they are conflicting with the old minima theme.
Please further flesh the page out, giving it a mobile first, minimalistic modern design. Keep it clear, precise and minimal, so that I can build on it and adjust it. It should however already pass as a home page.

--- 

I started extracting pieces/ components from other personal pages, that I would first like to fix and minify, before porting them to my own personal page. Please look into /drafts/featured_posts/index.html to find the first extracted component -- the featured posts. Please check out index.html and the snipped.css style file. Do the following:
* replace extracted fonts with a fitting alternative that is preinstalled on most PCs. Get rid of the font folder
* delete any images in the images folder, that are not used in index.html
* replace the css class names with descriptive class names
* make the html structure much simpler, without changing how the page looks. This is to make it simpler to port. Scrap unnecessary intermediate child element
* directly modify index.html
* fix a bug: the images for the featured projects arent high enough


---
This is okay but you massively altered the color of the page, from background to highlight color. For reference, I put the old featured post with intact colors in old_featured_posts. Please fix the color.
Additionally, please use better fonts. Please use Space Grotesk for the "Featured Project" above the title of the projects and Inter for the rest. Please put all colors and fonts in :root level variables for easy adjustability.


---

The colors are still massively incorrect due to the adjustemnts you made. For example, the .project-description initially had background-color: var(--light-navy), but you overwrote it with background-color: var(--darkreader-bg--light-navy, var(--darkreader-background-ffffff, #181a1b)); for some reason. This is incorrect. The original colors need to be restored.


---
# Blog Post Links
Should contain: Image, Date, Title, Subtitle, Tags, x Min read


I have added a new drafted html page under /drafts/blog_post_list/code.html. Please integrate this into the drafts/featured_posts/index.html and adjust the theme so it is matching.
What I like in the new /drafts/blog_post_list/code.html that should be carried over to the featured_posts/index.html:
* I like the tag styling -- introduce a css class for tags and apply it to the featured posts project-tags class (reread the file). However, please adjust the colors of the tags. Instead of using the highlighting/primary color, use a secondary text color
* I like that the Space Grotesk elements are uppercased. Please transfer this to the "Featured Projects" suptitle in the featured_posts html.

Please include a heading over the posts lists called "Recent Writing" with a right aligned link called "View All" or something like that. I will adjust this to match the rest later.


---
# Mobile Accessibility
We should now work towards mobile accessibility. Currently the design is not responsive and we need to adjust this. Please introduce breakpoints for mobile. Two main things need to be different on mobile:
## Layout
The layout containing the components must accommodate for the narrow display -- margins on the sides should be reasonably small. Currently, the margins are huge.
## Feature Posts Mobile Design
Zhe featured posts component currently uses an overlap between the image and the text, stacking them next to each other. This doesnt work on mobile. On mobile, the featured posts contents must be rearranged vertically.
First the image, then the text (title, subtitle, tags etc) that was previously on the right side. There should still be an overlap: If possible, apply linear gradient from transparent to the background color in the lower section of the image, so that the image basically fades out and the text starts where the image fades out.

---

This is okay, but the featured projects component doesnt look as I wanted.
The image should be above the title/ subtitle etc. The image should blend into the text, so the text needs to have negative margin to the top, to overlay the image and the text.


---

Next, I would like to add a short text above the rest. it shoudl read:

Hi, I'm 
Philip.
I'm a dedicated computer scientist passionate about web development and machine learning, committed to imparting knowledge through teaching.

The "Hi, I'm" should be above the name, in Space grotesk and primary color.
My name "Philip" should be beneath in a larger font size (see section header).
The text beneath should be secondary text explaining who I am.
This section should have reasonable margin to the next section. It would be great if there was a radial or elliptical highlight gradient behind my name, in muted lighter background color.
---
This is okay, but the gradient is barely noticable. It should be behind the section, not behind the name, coming in from the left and being big.
---

We should make some quality of life changes:
* please remove the margins for the sections and instead use display flex on the container and specify a gap. 
* the featured posts are left or right aligned in alternating order using the :nth-of-type(2n + 1) selector in css. Please change this so that their alignment (left or right) is specified via a class on the .project element -- left aligned is default, to right align it, a new .align-right class should be applied.

---

I have updated the snipped.css.
I need 2 more updates on the first section:
1. the gradient in the back should be radial and not limited to the text. Currently, the gradient is being cut off, potentially because of a overflow:hidden or something like that.
2. the hero section needs to have socials beneath: mail, github, linkedin -- i would like them to be centered and a line left and right to the icons. For now please use:
   <svg class="svg-icon grey">
   <use xlink:href="/personalwebsite/assets/minima-social-icons.svg#linkedin"></use>
   </svg>
linking to the assets in \personalwebsite\docs\_includes\social-icons

---

Next we need to add a basic footer and header.
The footer should just contain a copyright and have a slightly darker color than the rest of the background.
The header should contain right aligned links to "Blog" and "About Me"

---
I adjusted snipped.css.
We need some quality of live changes:
I dont like the margin: 0 auto; properties, as this makes margins arbitrary. I want the width of the main section on pc displays to be limited to a set width: a normal width for nearly all content and a wide setting for some very important things that need width -- currently only the individual featured projects. I believe the normal width could be 700px and the wide setting could be 1000px. Please use variables.

This is not what I was asking for. Only the individual featured projects are supposed to be of higher width. This excludes the heading. The posts should also be centered, so that the center of the narrow elements is the same center of the wide elements.

---

Please adjust the variables in the :root of the snipped css section to be more generic. Instead of navy, use a name that is independent of the exact color, for example --background. Same for the primary color (--green) and the text colors (use primary, secondary, tertiary for the colors).
Please also make sure that the font sizes are stored in the :root. It would be best to have rem sizes and then define sizes they are relative to on the containing element. Keep the font sizes of everything the same while reworking it. Note that the font sizes for featured projects are currently larger (keep it like that), so the containers need larger font sizes, so that the title, subsection, tag font sizes as defined in the variables adjust to that.

---

# About

I now added a prototypic about page to the project as about.html. This is a prototype that was generated and does not use the same theme. The first thing that is now required to do is to adjust this prototype to the rest of the website -- so the same theme the index.html uses. To do so, it should use the snipped.css, but anything new specific to the about page should go into a new about.css file.
The prototype is good but a few adjustments need to be made while transferring it:
* use the same color scheme, font size variables and basic layout that index.html uses.
* use the same socials style for the socials icons as defined in index.html
* replace selected writing with "Posters" and put 2 made up poster titles there with made up conferences -- this should use the same styling as the blog post listings in index.html
* Tech & Tools should use tag styling with a bigger font size (use the rem font sizes)

---
Check /drafts/featured_posts/. The about.html page you just created from the about_prototype.html basis has several issues. To help fix the issues I have put the prototype you started with into about_prototype.html. The goal was to use the prototype and adjust it so that it matches the theme and styling of the home page index.html and put new styles into about.css.
Issues:
* The Experience section is badly messed up. The css does not seem to work. Please recreate the section just as it was in the prototype, with the only difference being font family, size and colors.
* The posters should not use images, remove the images.
* Tech and Tools Tags need to be bigger than the rest.
* Please use profile_pic.png (just created it) as the profile picture.

---

I made some small adjustments to the code.
Could you adjust the about html and css so that when viewing the page on desktop, the profile header and hero-socials sections are placed left to the main section in a narrow container, in the best case dynamic minimal width so that everything fits without line breaking


---


I would like to now start merging. As a first step, I want to merge the about.html page with the about.css styling into the jekyll docs folder. To do so:
* about.html needs to be moved to /docs/_layouts/about.html
* the layout of docs/about.markdown needs to be changed to about (instead of about_page)
* the snipped.css and about.css styles need to be moved to the appropriate folder -- likely docs/_sass. Please rename snipped to something like main.scss. The styles must then be appropriately be included in the about.html page.
After you completed, I will test it using bundle exec jekyll serve

---

Next, lets do the same for the index.html page, that needs to be merged into docs/_layouts/home.html.
Please also extract information into a data file in _data. For now, create a new data file _home.yml and put any information in the home.html that is not layout or styling. For the featured posts and recent writing, please use the posts written by me and expand them by the missing fields (such as X min read). Consult /docs/_layouts/home_old.html for information about the featured posts and recent writing templating.


---

Next, we need to start cleaning up the layouting. Please extract components from about.html and home.html that are recurring, such as featured_post, blog_entry, footer, header, etc in _includes components, and include them into the html file. Please also clean up the data while doing so. Restructure the data files, so that data specific to the pages stays in the corresponding data files, while data data is used across page (e.g. my name) is put in another data file.

---

Please create new pages for /blog and /blog/TAG that will replace the old /posts and /posts/TAG as defined in /docs/_layouts/post.html and posts.html. You may consult these files for the templating logic. Please create them so that they match the styling in home.html and about.html and they are reusing components already used by these -- most importantly the blog_post.html preview in _includes.


---

This works reasonably well, but there are 2 things I would like you to change:
* scrap the posts title and put the posts title in place of the "Filter by Tags" title. Additionally, highlight the tags based on the url. If the posts are filtered for "Computer Science" tag, then this tag should be highlighted, not the "All Posts" tag.
* This approach unfortunately requires the generation of filtered blog pages for every tag -- like /docs/filtered_by_computer_science.markdown, which is tedious. Is there a way to write code so that upon building, Jekyll will scan all posts for tags, collect the tags, and build these pages internally?

---

You are in a Jekyll Personal Website project. We have already progressed in updating the old website theme and created several layouts and includes. We have created a home, about and blog page, which you can find in /docs/_layouts/home.html, about.html and blog.html. We now need to update the post pages, that are used to show the posts of the site.
To achive this, these things must be done:
* the /docs/_layouts/post.html layout must be modified to instead use the page wrapper. This must be done carefully so that the content of the post stays identical, it is still rendered correctly, but the wrapping html is no longer base.html, but page_wrapper.html.

The issue here is that during the update, we build in new files additional to the old ones, which introduced a lot of old styling that is conflicting with the new one (for example, same class names, but old styles are deprecated).
The old wrapping layout (base.html) imports the old styles (located in /docs/_sass/minima and subfiles), the new one (page_wrapper.html) the new styles (/docs/sass/_about.scss, _blog.scss, _main.scss).
To fix this, the old styles must be evaluated. Everything that corresponds to the old layout must be thrown out -- older header, footer, container styles etc. Only the styles that are relevant to the posts and the _includes components posts might use should be preserved and ported into a new style file /docs/_sass/_post.scss. The minima folder should be deprecated/obsolete afterwards and no longer be imported anywhere (keep it though in case the port is missing something).

You may check out the Oskam posts in /docs/_posts/ to identify important _includes components.

Afterwards, the posts page needs to use page_wrapper instead of base.

---


This is okay, but we now need to fix the design and layout. Currently, the design is not responsive. Additionally, the responsiveness definitions and wrapper definitions are scattered across /docs/_sass/_about.css, _main.css and _blog.html for the wrapping and layout. It would be great if this could be fixed, so that the layout css is in _layout that defines the responsive layout of the wrapping containers and this is also applied to the blog page.


---


Next, we need to rework and fix the font sizes applied on the webpage, as they are currently all messed up. This should result in a new /docs/_sass/_font.scss file, containing all settings for the font sizes.
Check the old variables in _main.scss. The issue with them is that they are using rem. The goal is to define variables such as --font-size-body and --font-size-blog-subheading and --font-size-figcaption in em.
They should then be applied to the corresponding elements. The goal is to define this once, define the default font size on the page, adjust the font size responsiveley.
Also, the font sizes should be used across element such as .blog-post-title and .project-title -- these are different sizes, but should use the same em font size variable. However, for the project-title the containing element needs to define a fontsize like font-size: 1.25rem to scale the size using a variable --featured-project-scale, as the featured project fonts must be better.

Please first port all font sizes into variables in the project, stating clearly what they are used for, then start unifying them carefully, approximately preserving the current font sizes.
The blog post font sizes are messed up, you may overwrite them with better values.



---


This is great for having all font sizes in one place, but the amount of different font sizes is really bad. It should also not vary from page to page, it should use the same variables on the about page as it does for the home page. The about page currently looks best and I would like to preserve this. Please execute 2 tasks:
1. drastically reduce the amount of font size variables, make them independent of the individual pages and make the variables descriptive, using variables for body, heading, subheading, figure-caption, tags, etc. Use these variables across the pages. Use state of the art relative font sizes to match top notch website and blogs.
2. make sure that on the home page, the featured posts and the blog posts are using the same variables for the heading, subheading, tags etc, but their container uses a different font size, so that the featured posts is naturally bigger.


---

I started making small adjustment, dont overwrite. We now need to make a lot of small adjustment.
* The code highlighting that was previously implemented does not work anymore, likely because the highlighting css is located in the discontinued _sass/minima folder. Please extract and apply the molokai.scss theme to the code.
* The code needs to use a fitting mono font, complementing Inter and Space Grotesk, that is clean and readable without being too stylized. Define this as a variable and apply to code.
$code-font-family: "Menlo", "Inconsolata", "Consolas", "Roboto Mono", "Ubuntu Mono", "Liberation Mono", "Courier New", monospace;
* The posters section in the about page needs to be updated to show additional information. I included new data for the posters in _data/about.yml -- posters should not have 1 link but multiple that are shown underneath with a label each and the posters need to have authors under the table, preferably formatted as "Nakkiran, P., Bradley, A., Goliński, A., Ndiaye, E."
* The tags should be extracted into an includes component that should be reused. The tags should be clickable to go to /blog/TAG/ to view posts with that tag.
* The header has a Home Link. Please place it to the very left and hide it conditionally when showing "/" (Home). Highlight the link that is currently active (if any) by highlighting it in the primary color (no underline as when you would hover it)
