Radiant Globalize2 Extension
===

About
---

An extension by [Aissac][aissac] that helps translating content in [Radiant CMS][radiant] using the Globalize2 Rails Plugin.

Tested on Radiant 0.8.

Features
---

* Provides the ability to translate your pages (title, slug, breadcrumb, description, keywords)  using the Radiant admin interface.
* Provides the ability to translate your snippets and layouts using the Radiant admin interface.
* Radius tags for accessing the locales and translations.
* Possibility to completely delete the translation for a page.

Installation
---

[Globalize2 Extension][arg2] has no known dependencies. [Globalize2 Rails Plugin][rg2] is bundled.

Because Globalize2 Extension keeps the settings in the `Radiant::Config` table it is highly recommended to install the [Settings Extension][rse]

    git submodule add git://github.com/Squeegy/radiant-settings.git vendor/extensions/settings
    
Finally, install Globalize2 Extension
  
    git submodule add git://github.com/Aissac/radiant-globalize2.git vendor/extensions/globalize2

Then run the rake tasks:

    rake radiant:extensions:globalize2:migrate
    rake radiant:extensions:globalize2:update

Configuration
---

###Settings

[Globalize2 Extension][arg2] keeps its settings in Radiant::Config table, so in order to use correctly the extension you need to create some settings:

    globalize.default_language = 'en'
    globalize.languages = 'ro,de'
  
Usage
---

You have the possibility to change the locale either on the pages/snippets/layouts index page, or on the page/snippet/layout edit page. Changing the locale using either options will change the locale for the entire application.

When you need to delete a translation, when on the page edit action, you need to check the "Delete Translation" checkbox, before saving the page. Saving the page with the checked "Delete Translation" will erase only the translation for that particular locale.

When creating a new page, the locale will be changed automatically to the default language.

###Available Tags

    * See the "available tags" documentation built into the Radiant page admin for more details.
    * Use the <r:locale /> tag to render the current locale.
    * Use the <r:locales /> tag to render the locales you use in the application.
    * Use the <r:with_locale /> tag to temporarly switch the locale within the block.
    * Use the <r:if_translation_title /> and <r:unless_translation_title /> tags to render the page only if/unless the title is translated.
    * Use the <r:if_translation_content /> and <r:unless_translation_content /> tags to rander the page only if/unless the content is translated.

TODO
---

Contributors
---

[rg2]: http://github.com/joshmh/globalize2
[aissac]: http://aissac.ro
[radiant]: http://radiantcms.org/
[rse]: http://github.com/Squeegy/radiant-settings
[arg2]: http://blog.aissac.ro/radiant/globalize2-extension/