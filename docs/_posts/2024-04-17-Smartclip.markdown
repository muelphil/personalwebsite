---
layout: post
title:  "Smartclip"
date:   2024-04-17 10:31:42 +0200
tags: ["computer science"]
title-image: 'Smartclip/title_image'
abstract: "Smartclip, currently in development, resembles Apple's Spotlight feature but offers an array of advanced features. These include extensive customization options, a clipboard manager, translation tools, and much more. Stay tuned for updates!"
short-abstract: "Smartclip, currently in development, resembles Apple's Spotlight feature but offers an array of advanced features. These include extensive customization options, a clipboard manager, translation tools, and much more. Stay tuned for updates!"
excerpt_separator: <!--more-->
---

Info on Smartclip (Content)

- [Github Releases Page](https://github.com/muelphil/smartclip?tab=readme-ov-file)
- [Color Scheme Generator](https://muelphil.github.io/smartclip-color-scheme-generator/)
- 
# Installation

Smartclip is currently in closed beta. If you want to test the application, e-mail me!

# Directories

Smartclip will create a `.smartclip` directory in your home directory on installation. This is used for example to store the settings in the `settings.json` file. You can
manipulate hidden settings (settings that are read only in the application) by modifying `settings.json` while Smartclip is not running (Close it first using rightclick on the tray
icon => "close")

# Plugins

The core of Smartclip is the Prompt line. Smartclip furthermore consists of multiple plugins. One of these Plugins (by default the Clipboard) is the basic Plugin, that will show up
whenever you open Smartclip using the hotkey (by default `ctrl+shift+V`). You can open the other plugins by typing the id of Plugin (for example `start` for the Start Plugin)
followed by a Space. This will open the Plugin. To get back, simply press `backspace`.

The Settings can be opened the same way: type `settings` followed by a Space, or alternatively press the little wheel icon on the right side of the prompt line.

In the following there is an overview of the different plugins, their ids and their functionality.

## Start (`start`)

{% include image.html url="Smartclip/Plugin_Start" %}

The Start Plugin allows users to quickly search for and start installed applications, as well as locate files within predefined, indexed directories. This plugin streamlines
workflow by providing fast and efficient access to essential programs and documents.

- search local applications
    - smartclip will take longer on first start for searching for all applications and caching the icons
    - icons are currently buggy (work in progress)
- special actions
    - shutdown, sleep, restart, hibernate
- set directories to index in the settings to index directories and search for files in these directories
    - there is a max depth and a max amount of files currently hardcoded (work in progress)

## Clipboard (`clip` - default Plugin!)

{% include image.html url="Smartclip/Plugin_Clip" %}

The Clipboard Manager allows users to store and retrieve clipboard entries, enhancing productivity by providing easy access to previously copied items for reuse in text input
fields.

- stores text copied to the clipboard
- multiple types of clipboard entries (detected by parsing, clipboard storage or in case of math through generation by smartclip)
    - plain
    - math
    - url
    - file
        - folder, file, image file
    - email
    - code
- prepend special keywords for the entry types (file, url, math, image, mail, code) to your query to only search for entries of that specific type
    - for example `url youtube` - only url entries that include youtube
- actions based on the type of clipboard entry, use context menu by clicking the 3 dots or by pressing `shift+enter` on the selected entry
    - for example email entries allow for the action "send email to..." opening your default mail application
- use `alt+1-9` to paste an entry by position
- favor entries, so that they get stored for future sessions

## Leo Translator (`leo`)

{% include image.html url="Smartclip/Plugin_Leo" %}

The Translation Plugin simplifies and accelerates translations with a single shortcut key, allowing users to instantly translate and paste words in various languages. This plugin
enhances efficiency, making translation effortless and seamless.

- uses Leo in background for searching words
- displays results sorted by categories (nouns, verbs, object)
    - use `ctrl+down/up` to jump between categories
- paste words instantly by pressing enter on a selected word
- "did you mean..." for when typos happen
- use `ctrl+shift+L` while highlighting a word in another application to automatically copy the word to Smartclip and search for it, press enter to replace the highlighted word
  with the result
    - try it out:
      <textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
      Haus
      Bank
      Wörter
      schnell
      </textarea>

## Emoji Picker (`emoji`)

{% include image.html url="Smartclip/Plugin_Emoji" %}

The Emoji Picker Plugin enables users to effortlessly browse and select emojis, enhancing text input fields with a fun and expressive touch. Seamlessly integrated and easy to use,
it enriches user interactions within your application.

- use arrow keys to navigate
- use mouse click or enter to paste selected emoji
- use alt + enter or alt + mouse click to show alternate versions (emojis with alternate versions have a grey border around them)
- use shift + enter or shift + mouseclick to store multiple emojis, press delete to remove one emoji from the stack, press enter to paste all the stored emojis
- search using german or english. The search function uses the suggested words from Whatsapp [that you can find here](https://web.whatsapp.com/emoji_suggestions/en.json)
    - for german + english I simply took both, pasted them into the chrome console as JSON objects and used {...en, ...de} to merge them, saving the result to a new file
- Use the skintone and gender radio buttons to select the corresponding alternate of all emojis that have alternates

## Math (`math`)

{% include image.html url="Smartclip/Plugin_Math" %}

The Math Plugin enables users to convert LaTeX input into SVG, PNG, or Unicode math formulas, providing a versatile tool for pasting beautifully rendered mathematical expressions.
With support for MathJax and PdfLatex (if installed), this plugin enhances text with precise and visually appealing math content.

- provide a query in a math markup language and press enter to paste the math in the selected format
- input methods
    - latex: `f:\mathbb{R}\mapsto\mathbb{R}`
    - asciimath: `f: RR |-> RR`
        - for unicode I use a custom translation from latex to ascii that is based on [this specification](https://asciimath.org/)
- parsing methods
    - pdflatex - uses local pdflatex.exe - please make sure it is present!
    - [MathJax](https://www.mathjax.org/)
- output methods
    - SVG
    - PNG
    - Unicode
- options for selecting the color, the size, the resolution (how many pixels are generated per paste height/width in pixel) and whether to use displaystyle

## Remind me (`rm`)

{% include image.html url="Smartclip/Plugin_RemindMe" %}

The RemindMe Plugin enables users to set reminders effortlessly by typing a date and/or time in natural language followed by a task. This intuitive yet minimalistic plugin
simplifies task management, ensuring you never miss anything important.

- use query to generate Reminders, that consist of a time and a task
- use the word "to" to explicitly separate time and task
- time detects any combination of the following:
    - keyword `in`
        - `in 10 mins and 30 seconds`
        - `in an hour`
        - `in 4d 30m 20s`
    - keyword `at`
        - `at 20`
        - `at 20:30`
        - `at 8:30 pm`
    - time
        - `20:00`
        - `8pm`
        - `8:30pm`
        - does not detect just `20`, use `at 20` instead
    - keyword `next`
        - `next month` (first day of next month)
        - `next week` (next monday)
    - weekdays
        - `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`,
        - sets date to the next occurence of that weekday in the future
    - tomorrow
        - `tomo`
        - `tomorrow`
    - special times (only when time is not provided in another way)
        - `morning`: 8:00
        - `lunch`: 12:00
        - `noon`: 12:00
        - `afternoon`: 14:00
        - `evening`: 17:00
        - `dinner`: 18:00
        - `night`: 20:00
    - dates
        - `01.01.1970`
        - `15.4.`
        - `15.4`
        - `15.4.25`
        - `15.4.2025`
        - `15-4-25`
        - `15/4/25`
        - currently not detected: `1 September 22`, `31 Dec 2023`, `2024/12/29`
- task is anything after the keyword `to`, anything left of the time specification (query from start until first occurence of `to`) after parsing will be prepended to the task

## Funcs (`funcs`, Work in Progress, Preview)

{% include image.html url="Smartclip/Plugin_Funcs" %}

The Function Plugin offers a glimpse into the main app's capabilities by activating various functions. These functions can modify features such as Clipboard behavior, providing
users with a preview of the app's full potential.

### Formatting

- format languages by positioning cursor in textfield with code to be formatted
- alternatively: only select the part that should be formatted
- open the functions plugin (`funcs`) and select `formatJs`
- currently supports languages
    - xml, rust, javascript, html, typescript, css, json, yaml(?)
    - actually: JSON, css

Try it out:

#### Java

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
public class Main { public static void main(String[] args) { System.out.println("Hello, World!"); } }
</textarea>

#### Rust

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
fn main() { println!("Hello, World!"); }
</textarea>

#### XML

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>
</textarea>

#### YAML

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
name: John Doe age: 30 address: street: 123 Main St city: Anytown state: CA
</textarea>

#### JSON

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
{"name": "John Doe","age": 30,"address": {"street": "123 Main St","city": "Anytown","state": "CA"}}
</textarea>

#### TypeScript

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
function greet(name: string): void { console.log(`Hello, ${name}!`); } greet('World');
</textarea>

#### CSS

<textarea style="width: 100%; min-height:200px;" rows="6" cols="50" style="display:block">
body { font-family: Arial, sans-serif; background-color: #f0f0f0; margin: 0; padding: 0; } h1 { color: #333; }
</textarea>

## Work in Progress

### Text Transform

# Work in Progess

- build your own plugins
- create your own themes

# Open Questions:

- should reminders generally be removed, even if they are snoozed?
- does the `ctrl+shift+L` shortcut work?

