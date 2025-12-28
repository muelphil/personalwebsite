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

We