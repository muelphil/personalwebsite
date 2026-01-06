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

---

I made some adjustments to about and styling of it. I would like you to further adjust the about page. Much of this page uses font sizes below body (1em), which is very small. It should only be used for things that are of low importance. For example, the poster description can barley be read. Please adjust the font size usage in the about page.


---


Next we need to fix the post header in _layouts/post.html, as it currently is screwed.

The post header should contain the following things:
* Header Image
* Post Info:
  * Navigation (Home > Posts >)
  * X min read <SPACE> Date of Publication
  * Title
  * Subtitle
  * Author(round cutout profile pic + name) <SPACE> Tags

I would like to use a similar approach for this header as I did with the project cards (see _includes/featured_project_card) regarding the layout.
However, for now I would like to first figure out the hierarchy for the Post Info, before aligning the header image and the text.
To achieve this, please make post_header a new include that puts the Header image first, then beneath the Post Info stacked as described above. Use the variables and possibly css classes already defined, but make sure it uses bigger font size by setting a bigger font size on the container so that the children scale based on this container font size.

Apply it to the posts (in post.html)

---

* The profile pic should not have an outline
* The profile pic should be clickable and link to the /about page
* the profile name should have the same subtitle as in the /about page (see about.yml)
* The tag needs to use the tags include to correctly render the tags
* the mins read need to be postfixed with " minute read" -- it currently only shows the minutes
* there needs to be a spacer between mins read and publication date, pushing publication date to the right (right aligned)
* comment out the Navigation for now
* The size is currently too big and should be a bit smaller, making it larger than the rest of the post, but still reasonable

---

This is problematic, as the tags.html in _include is broken now -- it is no longer correctly shown in the featured posts in home.html.
It also doesnt apply any css in the new post header include.
Please fix this
---
This is a good basis.
I would next like to adjust the previous and next blog posts suggested in the bottom of each post.
Instead of the current styling I would like it to use the _includes/blog_post.html component. However, please first adjust the component to feature a prop image-right that will put the image of the post right of the text and align the text right.
Then, use the component for the posts in the post.html file. On large screens, put then next to each other, with the previous post having the image left and the next post the image on the right.
On smaller screens, put then on top of each other.

---
I made slight adjustments, dont overwrite. Please also include a "include_description" input for the _includes/blog_post.html component (default: True) and disable it for the posts displayed at the end of post.html. Make sure that they are put next to each other on big screens. Also update the post-outro message to be more professional and engaging.


---

Lets look into the project card in home.html. They are responsive and change when below 768px.
Between 1080px and 768px another step should be introduced, where the image and the project description move closer to one another so they use less vertical space.
Please extract the css into a new file _project_card.scss and adjust the responsiveness. The responsiveness should be clearly defined per breakpoint (only one max-content statement per breakpoint, not many scattered ones.)

---

I would next like to implement a feature: Documents.
I want to use this to store content that are not posts but that I still want to link to from within posts or other points in my page, such as poster or publication abstracts, code snippets, declarations, etc.
It would be great if this could be implemented so that I have a docs/_documents folder that contains documents as markdown and that get rendered under /docs/document title. Each document should specify a title and optionally a date. They should contain markdown. It should be rendered as markdown, similar to what post.html does, but without everything post specific and without the fancy title etc. -- only the title and the date/time if present.
Create 2 dummy documents and link to them from the about page -- just put the links somewhere where i can easily delete them after trying.


---

I have added links in about.yml to the documents. The issue is that these links must include the prefix necessary for github pages hosting (/personalwebsite) and they also open in a new tab. It would be preferred if:
* the links open in the same tab
* I would not have to add /personalwebsite prefix in the about.yml page
* I could also put download links there, for example personalwebsite\docs\assets\documents\Eurips_Poster_2.pdf to download the poster.

---

Now I would like to adjust the headers layout, keeping the post-header-info and post-header-image elements identical but arranging them next to each other depending on the screen size.
I would like this to be similar to _includes/featured_project_card.html. You may reuse css from there, but create a new css file for the _post_header_title.scss
On bigger screens (min 1080 px), the items should be put next to each other -- image on the left, text on the right, using the .wide-content approach to exceed the width (use that class).
On smaller screens, the text should be beneath the image, but moved up with negative margin, so that there is an overlap. The image should have a gradient at the bottom so that the text is still readable. Please consult \docs\_sass\_project_card.scss for how this was implemented for the project cards.


---

I would like you to implement 2 more _include components that I may use in my posts:
* Scientific Reference: This should take a shortcut, title, list of authors (as string), markdown link text, year, optional note and render it like:
[shortcut] *Author List* (Year) **Title**. optional note, link text rendered from provided markdown
and should contain an anchor link to the shortcut so that I can include links in my posts to the reference that I will put at the end.
* A clickable link block, to link to other pages. This should be rendered in 2 columns, left: title image of the link, right: (stacked vertically) author (optional), title, text, link (link icon and link after)

Please implement these 2 includes and show their usage in docs/_drafts/2024-04-12-example3.markdown by including 2 items. Use some random data as defaults. When linking to other pages in the future I will extract the link title image etc myself, use a random link you know of for now.


---

The references look great, but the links to website unfortunately did not work well. They are displaying the <a> tag in plain text. Also, they are taking up a little too much space right now. They should not use a larger font size for the subtext than the body. they should be more compact. Can you please fix these issues?



---
Please next look into the post header again (docs/_includes/post_header.html). This uses a title image and text, that it arranges based on the responive design. However, some posts dont have a title image. Can you please make sure the posts still work in these cases? When there is no title image, the text should be displayed without putting them left, right or to the top. Just the text (header, subheading etc.)


---
I think you are right. I have reverted the project to the state prior to the jekyll assets implementation.
I want to instead propose the following approach:
Please rename assets/images to assets/content -- the content for posts, a nested folder structure containing everything that will be directly shown in posts.
Write a powershell script that uses compression and resizing of the videos using ffmpeg and images using imagemagick `magick`, and create a folder assets/content_compressed with the compressed images, image sourcesets and videos. Make sure that this script only creates compressed version, if there is not already a compressed version in the output folder, so it doesn't repeat unnecessary work. All _includes and posts need to be scanned for image usage and the used media paths needs to be updated.

For images, use this as reference:
## PNG → responsive AVIF (CLI)

### 1) Resize + encode (one loop)

`for w in 320 640 960 1280; do
  magick input.png -resize ${w}x png:- | \
  avifenc - image-${w}.avif --cq-level=30 --speed=6
done
`

### 2) Result

`image-320.avif
image-640.avif
image-960.avif
image-1280.avif
`

### 3) HTML srcset

`<img
  src="image-640.avif"
  srcset="
    image-320.avif 320w,
    image-640.avif 640w,
    image-960.avif 960w,
    image-1280.avif 1280w"
  sizes="100vw"
  alt="">
`

### Defaults (web)

* `cq-level=28–32`
* resize first
* keep original PNG
* add WebP fallback if needed

For Videos, use:
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 0 -crf 32 -deadline good -an output.webm.

Please create the powershell script and make sure that all docs/posts and docs/_includes are using the correct compressed_content folder, that is the output folder of the compression.


---
Looking into the Oskam Post, not a single image is showing up correctly. This needs to be fixed. An examples of this:

ZTL-Kamera image:
What is renders: /assets/content_compressed/Oskam/ZTL_Kamera-640w.avif
Correct would be: /personalwebsite/assets/content_compressed/Oskam/ZTL_Kamera-960w.avif

It is basically missing the /personalwebsite in front, which I had originally solved using <img src="{{ include.url | relative_url}}"> (see relative_url).
In the best case I would like to provide the image without the prefix or postfix so instead of /personalwebsite/assets/content_compressed/Oskam/ZTL_Kamera-960w.avif, I would just like to provide "/Oskam/ZTL_Kamera". Can you make this possible and also look into the Oskam post (docs/_posts/2023-07-10-Oskam.markdown) and fix all the image links?

---
Still not working: When supplying Oskam/ZTL_Kamera, this turns into /personalwebsite/assets/content_compressed/OskamZTL_Kamera-640w.avif -- so the / in the path is missing between Oskam and ZTL_Kamera.


---

Great. Some include components are not yet working though. Please look into the following _includes components and fix them with the new image approach:
* gallery.html
* featured_project.html / featured_project_card.html

---

You are in a Repository of a personal website hosted on Github Pages using Jekyll. You will find the main dirs in the directory docs:
* _posts: the posts as markdown files
* _drafts: the drafts that get moved to _posts when completed
* _includes: important html definitions that can be included by layouts and posts
* _layouts: The layouts for the different pages
* assets: The assets (images, videos, documents, icons) for the page
* _sass: the themes and styles of the pages, imported by assets/css/main.scss

I am currently writing on my new post: _drafts/2025-12-31-reasoning-models.md. I want to include some reasoning model conversations to showcase reasoning model behaviour. For this I need custom html and styling for the conversation bubbles.
I have created _inludes/posts/reasoning-models/ with a styling file for the new css (conversation.css), a target html file for a conversation qwen-2+2-conversation.html and a markdown file, holding the conversation that you are supposed to integrate into the html file: qwen-2+2-conversation.md.
The goal is for the html to integrate with the rest of the pages styling. It should use conversation bubbles (justified right for user prompt, justified left for the assistant response). The user prompt should read uppercased "user prompt" in label font above the input text. For the assistant response, I need it to be in 2 sections: "reasoning trace" and "final answer". They should be in one rounded conversation bubble, with a secondary background color and the final answer should be in a conversation bubble within this conversation bubble, no margins, with primary background color. The reasoning trace should use secondary font color, with the think token control tags using tertiary color instead. The final answer should use normal text color. To keep things readable, the total conversation should not exceed 75vh. The conversation should be wrapped in a figure with a figcaption, as already styled in the main style of the page.

Please create the style that integrates with the rest of the styles on my website and put the conversation in qwen-2+2-conversation. Then, include this style at the very and of my markdown blog post.


---
This needs adjustment, as it is not how I wanted it. The conversation should not have a background color. Only the conversation bubbles should have a background color.
The scrolling should be within the conversation bubbles, so that all conversations are fully visible, but the conversation scrolls, if it is too long. If possible, that should only affect the reasoning trace, as this is longest. The user prompt and final assistant answer need to be always visible. This will likely require a wrapper div around the reasoning trace.
The user prompt and the final assistant answer need to have the same or similar background color. The reasoning trace needs a darker brackground color than the final assistant answer.

---

* Use https://lucide.dev/icons/?search=github
* front page swirl of colors
* Mono Font: Space Mono
* Space Grotesk -> Expletus Sans
* Albert Sans
<link href="https://fonts.googleapis.com/css?family=Albert Sans" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Expletus Sans" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Space Mono" rel="stylesheet" type="text/css">

<style>
* {
 font-family: 'Space Mono', sans-serif;
}
</style>
<style>
* {
 font-family: 'Expletus Sans', sans-serif;
}
</style>
<style>
* {
 font-family: 'Albert Sans', sans-serif;
}
</style>

* lava lamp effect in about me