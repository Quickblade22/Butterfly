# Changelog

<!--ENTER CHANGELOG HERE-->

## 2.0.0-beta.7 (2023-08-18)

* Add pen painter icon customisation ([#467](https://github.com/LinwoodDev/Butterfly/issues/467))
* Add locking for transformation ([#455](https://github.com/LinwoodDev/Butterfly/issues/455))
* Add data directory setting for android ([#482](https://github.com/LinwoodDev/Butterfly/issues/482))
* Add image scale setting ([#454](https://github.com/LinwoodDev/Butterfly/issues/454))
* Add double click to rename ([#452](https://github.com/LinwoodDev/Butterfly/issues/452))
* Add ability to rename waypoint
* Add ability to rename layers from navigator
* Add thumbnail for components ([#474](https://github.com/LinwoodDev/Butterfly/issues/474))
* Add toolbar for stamp painter ([#474](https://github.com/LinwoodDev/Butterfly/issues/474))
* Add components navigator page ([#474](https://github.com/LinwoodDev/Butterfly/issues/474))
* Add scaling functionality for stamp painter ([#474](https://github.com/LinwoodDev/Butterfly/issues/474))
* Add ctrl+a shortcut on all painters to open the hand painter and select all ([#450](https://github.com/LinwoodDev/Butterfly/issues/450))
* Rename Export > Data to Export > Document
* Fix portable linux build
  * Fix script.sh
  * Set executable permission on script.sh and butterfly binary
* Fix deleting pages
* Fix duplicated name on sync mode bottom sheet
* Upgrade to flutter 3.13

View all changes in the blog: https://linwood.dev/butterfly/2.0.0-beta.7

## 2.0.0-beta.6 (2023-08-04)

* Add sort order ([#469](https://github.com/LinwoodDev/Butterfly/issues/469))
* Add move painter ([#473](https://github.com/LinwoodDev/Butterfly/issues/473))
* Save sort state ([#469](https://github.com/LinwoodDev/Butterfly/issues/469))
* Save deleted images in cache
  * Fix pasting images not working ([#465](https://github.com/LinwoodDev/Butterfly/issues/465))
* Add to selected after transformed ([#478](https://github.com/LinwoodDev/Butterfly/issues/478))
* Recode shape painter
  * Add center, 1:1 features ([#476](https://github.com/LinwoodDev/Butterfly/issues/476))
* Improve save state icons
* Improve import painter position
* Improve hit calculation on single point pen elements
* Improve performance of quick start view in home page ([#459](https://github.com/LinwoodDev/Butterfly/issues/459))
* Improve context menu position ([#468](https://github.com/LinwoodDev/Butterfly/issues/468))
* Align source and sort by in home page
* Set position to clicked when pasting ([#468](https://github.com/LinwoodDev/Butterfly/issues/468))
* Fix selection not updated if deleted
* Fix native title bar error on mobile devices
* Fix internet problems on android ([#457](https://github.com/LinwoodDev/Butterfly/issues/457))
* Fix position when pasting elements ([#468](https://github.com/LinwoodDev/Butterfly/issues/468))
* Fix corner hit detection on hand tool when zoomed
* Fix rotation when selecting multiple elements ([#472](https://github.com/LinwoodDev/Butterfly/issues/472))
* Fix ruler moving speed when zoomed ([#480](https://github.com/LinwoodDev/Butterfly/issues/480))
* Fix path selection rect when rotated ([#475](https://github.com/LinwoodDev/Butterfly/issues/475))

View all changes in the blog: https://linwood.dev/butterfly/2.0

## 2.0.0-beta.5 (2023-07-21)

* Add navigation rail to large ui ([#444](https://github.com/LinwoodDev/Butterfly/issues/444))
* Add specific navigator pages to menu in mobile ui ([#442](https://github.com/LinwoodDev/Butterfly/issues/442))
* Add keyboard shortcuts
  * Add ctrl + a to select all to hand painter ([#436](https://github.com/LinwoodDev/Butterfly/issues/436))
  * Add del to delete selected to hand painter ([#435](https://github.com/LinwoodDev/Butterfly/issues/435))
* Add svg icon to asset file type svg
* Add asset painter ([#431](https://github.com/LinwoodDev/Butterfly/issues/431))
* Add clipboard (cut, copy, paste) ([#422](https://github.com/LinwoodDev/Butterfly/issues/422))
* Add transformation functions for markdown renderer
* Fix move transformation on image renderer
* Fix mobile ui
* Fix hand tool corner selection not working on mobile
* Fix waypoints not updating in navigator
* Fix background won't be loaded
* Fix position when scaling elements
* Fix window when native title bar is enabled
* Fix full screen and maximize window ([#449](https://github.com/LinwoodDev/Butterfly/issues/449))
* Fix add asset dialog not working
* Fix baking not working on presentation mode
* Fix painters not updated in selection property view

## 2.0.0-beta.4 (2023-07-14)

* Add custom mouse cursors for painters ([#426](https://github.com/LinwoodDev/Butterfly/issues/426))
* Add spacer painter ([#424](https://github.com/LinwoodDev/Butterfly/issues/424))
* Add full screen painter ([#432](https://github.com/LinwoodDev/Butterfly/issues/432))
* Add move by dragging selection, add rotate button ([#410](https://github.com/LinwoodDev/Butterfly/issues/410))
* Add floating toolbar ([#445](https://github.com/LinwoodDev/Butterfly/issues/445))
* Add settings animation and blur
* Add responsive main view ui
* Recode hand tool to allow realtime transformation
* Improve window title bar
* Fix window does not open with start in fullscreen mode enabled ([#430](https://github.com/LinwoodDev/Butterfly/issues/430))
* Fix resizing with multiple elements ([#434](https://github.com/LinwoodDev/Butterfly/issues/434))
* Fix resizing with rotated elements
* Fix not waiting for creating default templates on native platforms
* Fix native title bar setting not saved
* Fix home page not refreshing
* Fix save indicator on web

## 2.0.0-beta.3 (2023-07-07)

* Add image background ([#419](https://github.com/LinwoodDev/Butterfly/issues/419))
* Add ability to customize position of the toolbar ([#408](https://github.com/LinwoodDev/Butterfly/issues/408))
* Add option to rename page
* Add changing of page after adding a new page
* Add pages button to the toolbar ([#411](https://github.com/LinwoodDev/Butterfly/issues/411))
* Add real fullscreen mode ([#421](https://github.com/LinwoodDev/Butterfly/issues/421))
* Don't ask for name when adding a page (single click) ([#411](https://github.com/LinwoodDev/Butterfly/issues/411))
* Fix many properties (background, animations, ...) missing when opening a document
* Fix name check not allowing spaces, - and _
* Fix zoom enable setting will be ignored
* Fix setting navigation clears page history
* Fix elements can't be moved on import ([#423](https://github.com/LinwoodDev/Butterfly/issues/423))
* Reduce size of title text field
* Reduce size of window buttons
* Remove delete painter. Use the delete button in the properties instead or move the painter to the right of the add button

## 2.0.0-beta.2 (2023-06-30)

* Add label context menu
* Improve document load performance
* Fix export button when loading absolute document
* Fix label toolbar if text is empty
* Fix updating of tool selection
* Fix line breaks in markdown
* Fix core pack styling
* Fix pack exporting
* Fix importing assets from home page
* Fix importing of documents in web
* Fix changing elements multiple times in property view
* Fix missing title in locale bottom sheet
* Fix wrong title in design bottom sheet
* Fix loading non documents with open with ([#417](https://github.com/LinwoodDev/Butterfly/issues/417))

## 2.0.0-beta.1 (2023-06-23)

* Add grid view
* Add editing of label elements
* Add move elements in the z axis ([#396](https://github.com/LinwoodDev/Butterfly/issues/396))
* Add saving indicator ([#402](https://github.com/LinwoodDev/Butterfly/issues/402))
* Add pack remote directory ([#389](https://github.com/LinwoodDev/Butterfly/issues/389))
* Add folder structure to pages ([#398](https://github.com/LinwoodDev/Butterfly/issues/398))
* Add stacktrace to error page
* Use delay on reorder item for painters
* Use delay on files in home page
* Validate file name on creation
* Migrate selection context menu to new menu button widget
* Improve performance
* Fix loading files with file args
* Fix not working spacebar in label
* Fix layer view not updating when layer visibility changes
* Fix page won't be saved if autosave is disabled on page change
* Fix importing of assets
* Fix showing selected settings page in mobile
* Fix flashing navigation bar if not enabled

## 2.0.0-beta.0 (2023-06-12)

* Rebuild area painter handler
  * Areas can now intersect
* Add version to pack metadata
* Add navigator ([#391](https://github.com/LinwoodDev/Butterfly/issues/391))
  * Waypoints view
  * Layers view
  * Pages view
  * Files view
* Add pages
* Add alpha to grid
* Add alpha to label
* Add dynamic height to toolbar
* Add shortcut indication to painters
* Add layers ui
* Add quality to image export dialog
* Add asset service to manage disposing of images
* Add more space for edit toolbar
* Add settings menu item button in top left corner
* Bump file version
  * Painters, export presets and tool are now global instead of page specific and was moved to a info.json file
  * Remove waypoint painter in favor of the navigator
* Migrate more components to material 3
* Rename native window title bar to native title bar
* Fix clearing history after navigating in behavior settings
* Fix moving of elements
* Fix migrating old documents
* Fix exporting documents on android
* Fix offset when selecting painters
* Fix alpha in color toolbar
* Fix creating default templates if directory doesn't exist
* Fix temporary handler
* Fix moving shapes
* Fix default template
* Fix changing color palette in color toolbar
* Fix duplicating core pack because of case sensitivity
* Fix opening of non butterfly files
* Fix position when moving of imported elements
* Fix snapping in grid when zoomed
* Fix label created empty text elements
* Fix backwards compatibility with stamp painter

## 2.0.0-alpha.4 (2023-05-21)

* Add markdown element
* Add modes for label painter
* Add foreground property for painter, markdown and text element
* Add extra file icon ([#374](https://github.com/LinwoodDev/Butterfly/issues/374))
* Include font in assets
* Fix connection title bar
* Fix zoom view showing above the property view
* Fix setting position in property view
* Fix name and description not updating in property view
* Show only window if title bar was set ([#385](https://github.com/LinwoodDev/Butterfly/issues/385))
* Remove tab shortcut to reset the document

## 2.0.0-alpha.3 (2023-05-15)

* Add archive format
* Add thumbnails on documents
* Add ability to open other files than notes from home page
* Add missing painter help pages
* Add popup menu when long pressing on window title bar
* Improve text update in zoom view
* Improve sorting at home page
* Move change document path to appbar
* Fix appearing zoom view and disappearing on focus
* Fix importing of documents
* Disallow saving in json format
* Remove save and load dialog (including load and saving from clipboard)
* Upgrade to flutter 3.10

## 2.0.0-alpha.2 (2023-05-05)

* Add option to change visibility of banner ([#372](https://github.com/LinwoodDev/Butterfly/issues/372))
* Add pt language
* Add nightly text to appbar if nightly version is installed
* Publish butterfly in the snap store
* Use text field in zoom view to change zoom level
* Use the best painter color based on the background color
* Use background on window buttons
* Make laser and text painter zoom dependent
* Fix installation path on windows to 64-bit ([#371](https://github.com/LinwoodDev/Butterfly/issues/371))
* Fix timeline colors
* Fix reload after resizing the window
* Fix reset does not replace templates
* Fix text span creation
* Fix select while zooming
* Fix overflow in settings dialog
* Fixing text replacing problems
* Remove file extension on file move dialog
* Remove settings button in main view

## 2.0.0-alpha.1 (2023-04-14)

* Add button to reset templates if quickstart is empty
* Add option to change shape in add dialog
* Add zoom enabled in personalization settings
* Add delete icon for painters
* Add system to change position of cursor on text by clicking on it
* Add box to text editing
* Add vertical arrow selection in text
* Add option to add core pack to update the current one
* Play at the beginning if the current frame is the last one
* Show path without leading slash in appbar
* Fix home page on smaller screens
* Fix rich text editor in label painter
* Fix DragToMoveArea on native title bar on desktop
* Fix infinite loop if action painter is first painter
* Fix selection system after removing current painter
* Fix file import on mobile devices
* Fix setting horizontal alignment of text
* Fix problems with presentation painter if paused

## 2.0.0-alpha.0 (2023-04-09)

* Add rich text
* Pack changes
  * Add styles to pack
  * Add color palette to pack
    * Improve color toolbar to reflect that color palettes are now saved in the pack
  * Add core pack
* Painter changes
  * Remove eraser element to improve performance (Breaking change)
  * Add waypoint painter
  * Rebuild add dialog
    * Add inserts of assets in add dialog
  * Remove right click menu from hand dialog
  * Rebuild pen renderer
  * Add new properties to pen painter
    * Thinning
    * Smoothing
    * Streamline
  * Move transparency property out of color into an extra slider
  * Rich text
    * Add label toolbar to support rich text
    * Add text cursor
  * Add presentation mode
    * Add animations
    * Add presentation toolbar with timeline
    * Add new mode for running a presentation
  * Replace pixel property in image element with source url as base64 data url
* Tool changes
  * Add check if ruler size is greater than 0
  * Move project settings in tools
* Template changes
  * Templates have now thumbnails
  * Templates will be created in the selected connection
* UI Improvements
  * Add home page
  * Remove open dialog in flavor of the home page
  * Rebuild top corner menu
  * Remove classic, yaru and adwaita theme
  * Use device accent color for default theme
  * Add zoom slider to the main draw page
  * Rename remote translations to connection
  * Replace listtiles in context menus to menuitembuttons
  * Add search at the top to search for text elements, areas and waypoints
  * Title is now smaller aligned in the top left corner to look better
  * Improve title bar to look more material 3 like
* Middle mouse behavior is now move as default
* Rebuild file format and add note for breaking changes
* Remove date format setting, documents have no name by default
* Add new butterfly logo
* Improve web file system
* Improve pdf export
* Restructure basic classes in api project
* Downloads
  * Add start scripts ([#304](https://github.com/LinwoodDev/Butterfly/issues/304))
* Bug fixes
  * Fix unicode characters in file path, fixes ([#336](https://github.com/LinwoodDev/Butterfly/issues/336))
  * Fix after Undo, Hand tool will be selected
  * Fix blank page after entering or exiting area mode
  * Fix global shortcuts

Things that need to be improved:
* Text tool
* Presentation tool
* Packs in general
* File format (there will be an automatic migration)

## 1.6.1 (2023-01-27)

* Fix new button
* Fix ruler gestures
* Upgrade to flutter 3.7

## 1.6.0 (2022-12-24)

Read the whole 1.6 changelog at <https://go.linwood.dev/butterfly/1-6>

<details>
 <summary>1.6 Nightly Changelog</summary>

## 1.6.0-rc.1 (2022-12-19)

* Fix precision of offset property view
* Fix permission error in windows setup
* Internal: Use map instead of this is

## 1.6.0-rc.0 (2022-12-16)

* Add themed color for ruler color and areas
* Area painter will now use the grid
* Shape painter will now use the grid
* Laser painter will now use the ruler
* Enable changing rotation of ruler with gesture
* Fix grid to be local to the screen
* Disable text for ruler for now

## 1.6.0-beta.0 (2022-12-09)

* Add tool window
* Add grid
    * The grid can be turned on and off
    * When moving elements, it will snap to the grid
* Add ruler

## 1.6.0-alpha.1 (2022-11-25)

* Add packs to storage and document
* Add packs dialog to top left corner menu
* Add stamp painter
* Add "Add to pack" button to area context menu
* Add action painter indicator
* Update text and icon for generic painter property view
* Fix remove of selection

## 1.6.0-alpha.0 (2022-11-05)

* Add laser painter selection view
* Add data path argument to the command line
* Add new folder button to move dialog
* Add dialog close on text field submit
* Show error if loading document fails
* Improve windows setup
    * Add dialog to decide if the program should be installed for all users or just the current user ([#306](https://github.com/LinwoodDev/Butterfly/issues/306))
    * Add icon for the uninstall window in the windows control panel ([#305](https://github.com/LinwoodDev/Butterfly/issues/305))
* Fix start in full screen on desktop ([#307](https://github.com/LinwoodDev/Butterfly/issues/307))

</details>

## 1.5.0 (2022-10-21)

Read the whole 1.5 changelog at https://go.linwood.dev/butterfly/1-5

<details>
 <summary>1.5 Nightly Changelog</summary>

### 1.5.0-rc.1 (2022-10-19)

* Add painters to default document
* Enable label editing when long pressing on a label
* Fix rect shape hit calculation

### 1.5.0-rc.0 (2022-10-15)

* Add delete button to color view
* Update hit calculator to reflect element exactly (path and shape)
* Update performance of path eraser
* Fix reset button in input controls customization
* Fix line shape transform
* Fix context menu handling on selection in hand painter
* Fix image export

### 1.5.0-beta.2 (2022-10-07)

* Add disabled colors to redo and undo painter
* Update color view
* Move property view to the top right corner
* Fix issues when trying to add undo/redo painters
* Fix opening of exported pdfs and zips
* Fix shortcuts
* Hide move handler
* Remove unused permissions on android

### 1.5.0-beta.1 (2022-09-30)

* Open url externally
* Fix temporary move handler
* Fix import on open dialog

### 1.5.0-beta.0 (2022-09-23)

* Add resize feature to selection
* Use move if painter index is zero
* Fix image open
* Fix empty background
* Remove hit calculator, use function insteads
* Remove temporary painter on creation

### 1.5.0-alpha.2 (2022-09-09)

* Separate behavior settings for each input type
* Add option to change painter using control and number
* Add move functionality if no painter is selected
* Fix start in full screen settings
* Fix grid view in file system dialogs
* Fix missing save of sync mode in settings

### 1.5.0-alpha.1 (2022-09-02)

* Add temporary painter
* Add new painters
  * Hand
  * Undo
  * Redo
* Remove hand, undo, redo buttons from general gui
* Improve UI and UX problems ([#280](https://github.com/LinwoodDev/Butterfly/issues/280))
  * Reset pointer on app hide
  * Add default behavior to not ask for area name
* Add option to load images, pdfs and svgs from open dialog
* Add option to start the app in full screen mode
* Fix gesture issues on area and shape painter
* Fix area change problem
* Fix divider on top right in native title bar mode

### 1.5.0-alpha.0 (2022-08-26)

* Add macos support (Thanks to batuhand)
* Add pdf export support
    * Add export presets
* Add mutli selection option
* Add property view
* Add native file opener for pdf, image and notes
* Add export button to data settings
* Add option to import files from file on pwa
* Improve context menu (add modal background, add new scale animation)
* Fix image import bug
* Use json converters to load/save json (fixes missing type and version info)

</details>

## 1.4.4 (2022-09-16)

* Fix line generation in shape painter
* Fix position and size issues when moving elements
* Fix gesture issues on area and shape painter and area change problem
* Fix sync mode won't be saved
* Reset pointer on app hide, see #280

## 1.4.3 (2022-08-20)

* Move directory on document path change and disable document change on android ([#254](https://github.com/LinwoodDev/Butterfly/issues/254) and [#255](https://github.com/LinwoodDev/Butterfly/issues/255))
* Fix reappearing strokes after delete ([#265](https://github.com/LinwoodDev/Butterfly/issues/265))
* Fix laggy moving ([#266](https://github.com/LinwoodDev/Butterfly/issues/266))
* Fix eraser cursor glitches ([#264](https://github.com/LinwoodDev/Butterfly/issues/264))
* Fix app bar title

## 1.4.2 (2022-08-12)

* Add sync modes
* Add cursor for eraser
* Add oval feature for circle shape
* Improve creation of shape and area when going in negative
* Fix area painter
    * Add name validation
    * Fix size validationa
* Fix undo/redo
* Change text fields to filled in remote create dialog
* Remove duplicated label element in plus popup menu

## 1.4.1 (2022-08-05)

* Add option to change data directory location on android
* Add turkish translation (thanks to ilker besken)
* Add constraint and export option to svg element context menu
* Add support for setting locale in embed mode
* Fix missing svg move indicator
* Fix exporting of image elements
* Fix svg renderer rect
* Fix native window title bar issues
* Fix performance on large documents when trying to open a context menu of an element
* Fix render time on large documents
* Fix slider do not update after changing outside of the slider
* Fix unintential behavior when deleting all elements in a layer
* Fix save button in embed mode

## 1.4.0 (2022-07-26)

Read the whole 1.4 changelog at https://go.linwood.dev/butterfly/1-4

<details>
 <summary>1.4 Nightly Changelog</summary>

### 1.4.0-rc.3 (2022-07-25)

* Add option to change data directory location on android
* Add turkish translation (thanks to ilker besken)
* Add constraint and export option to svg element context menu
* Add support for setting locale in embed mode
* Fix missing svg move indicator
* Fix exporting of image elements
* Fix svg renderer rect
* Fix native window title bar issues
* Fix performance on large documents when trying to open a context menu of an element
* Fix render time on large documents
* Fix slider do not update after changing outside of the slider
* Fix unintential behavior when deleting all elements in a layer
* Fix save button in embed mode

### 1.4.0-rc.3 (2022-07-25)

* Add native window title bar support
* Fix supported locales

### 1.4.0-rc.2 (2022-07-23)

* Add portuguese (Brazil) localization
* Disable updater on web
* Fix file import on remote
* Fix classic light theme
* Fix embedding mode
* Fix error when opening same file

### 1.4.0-rc.1 (2022-07-20)

* Fix save indicator
* Fix error when fetching version
* Fix save button
* Fix drag to move area
* Fix invalid parse of remote path
* Fix bake issues

### 1.4.0-rc.0 (2022-07-17)

* Add stylus button input
* Add hex input to color dialog
* Add constraints to shape painter
* Move save state in current index cubit to allow undo/redo
* Fix bake issues
* Fix wrong properties when resetting back to hand painter
* Fix ignored properties in area painter

### 1.4.0-beta.1 (2022-07-15)

* Add matrix invite link
* Rework multi input system
    * Add input gesture support (move with two fingers [#206](https://github.com/LinwoodDev/Butterfly/issues/206))
* Rework bake system
    * Fix undo/redo lag
    * Fix that you need to click multiple times to undo something
    * Disable buttons if you cannot undo/redo
* Add italian localizatiion
* Fix lag when opening/closing the color view
* Improve default theme to match with the documentation
* Change color of eraser to background color
* Add check to prevent adding duplicated locations to paths
* Remove unused color property in eraser painter

### 1.4.0-beta.0 (2022-07-08)

* Add offline sync
    * Add remote page to control all cached paths
    * Add sync button and dialog to file system dialog to see the status
    * Add sync button controller to all remote assets in file system dialog
    * Add sync background service 
* Switch license to AGPL
* Fixing shape editing dialog for elements
* Fix opening nested context menus

### 1.4.0-alpha.3 (2022-07-01)

* Add updater
* Add shape painter
    * Add rectangle shape
    * Add circle shape
    * Add line shape
* Add yaru and adwaita theme
* Show better display name for themes
* Change area icon
* Disable restart of the app after changing the personalization settings
* Add file extension registry on linux
* Add option to change color in pen context menu
* Add svg element
* Fix icon size in remote button
* Fix error if icon is invalid when adding remote
* Fix export in image element context menu
* Add check to prevent duplicated remote entries
* Change scale to slider in constraints dialog

### 1.4.0-alpha.2 (2022-06-24)

* Add remote storage ([#88](https://github.com/LinwoodDev/Butterfly/issues/88))
    * Add remote settings
    * Add storage option to template and open dialog
    * Specify remote in title
* Add loading indicator to file open dialog
* Exporting on web now downloads the file
* Remove cdns on the web
* Redesign settings with cards
* Fix settings rounded corners

### 1.4.0-alpha.1 (2022-06-20)

* Fix invalid namespace on android

### 1.4.0-alpha.0 (2022-06-17)

* Add laser painter to paint strokes temporarily
* Add duplicate to change document path
* Add color view to label, pen and laser painter
* Add spanish translation
* Add quality slider to pdf ([#184](https://github.com/LinwoodDev/Butterfly/issues/184))
* Add copy to change document path ([#180](https://github.com/LinwoodDev/Butterfly/issues/180))

</details>

## 1.3.2 (2022-06-10)

* Add quality slider to pdf
* Add material palette to default templates
* Fixing area issues
    * Fix bug when area has negative values
    * Fix bug when area is not visible when changing the painter
    * Fix app bar title does not change after exiting the area
* Improve spacing of selection rect based on the zoom
* Move android storage to external
* Center image on moving ([#185](https://github.com/LinwoodDev/Butterfly/issues/185))
* Fix image low quality
* Fix missing constraints button in image element dialog
* Fix window_manager errors on mobile devices
* Remove image painter for file-version < 5

## 1.3.1 (2022-06-03)

* Reimplement color field
* Fix bake issues when moving the camera with a gesture
* Fix move gesture relative to viewport
* Fix fill mode
* Fix hard edges in settings dialog
* Fix firefox bug when creating a new path
* Fix undo/redo buttons
* Fix invalid elements after changing the layer
* Fix background dialog slider
* Fix svg export
    * Only export elements that are in this bounds
    * Fix option to disable background
    * Fix offset of eraser mask
* Fix loading of templates in old version
* Add reset button in templates
* Ignore invalid templates

## 1.3.0 (2022-05-26)

* Fix bug where document will be cleared after removing a layer or rename a layer

Read the whole 1.3 changelog at https://go.linwood.dev/butterfly/1-3

<details>
 <summary>1.3 Nightly Changelog</summary>

### 1.3.0-rc.2 (2022-05-22)

* Fix layout on bigger screens
* Fix image export
* Improve position of submenus

### 1.3.0-rc.1 (2022-05-18)

* Fix undo on scrolling
* Replace text buttons to icon buttons in dialog actions
* Fix appbar title
* Change scroll focus point relative to the zoom
* Fix zoom multiplier when using multiple fingers
* Add alwaysontop, move fullscreen to right top corner on desktop
* Add tooltips on window buttons
* Disable window buttons in full screen
* Fix file system on web (Creating directory if not exist)#
* Fix file system directory error
* Fix baking issues

### 1.3.0-rc.0 (2022-05-13)

* Implement drag resize area and popup window menu on desktop platforms
* Fix pixel ratio
* Fixing safe area bug in settings
* Fix embedding
* Upgrade to flutter 3
* Show error message if an error occurred while inserting

### 1.3.0-beta.2 (2022-05-06)

* Implement embed functionality
* Fixing a lot of bugs ([#158](https://github.com/LinwoodDev/Butterfly/issues/158), Thanks to vi)
    * Add move/duplicate indicator
    * Add layer suggestions
    * Add multi element selection context menu
    * Remove delete confirmation when trying to delete an element or a painter
    * Fixing pixelated view when paint on it
    * Fix error when trying to delete the painter
    * Fix undo does not work on path eraser
    * Fix Drawing with multiple fingers leave multiple trails
    * Fix error while trying to delete an element
    * Fix error after deleting a painter
* Remove settings window buttons
* Change size of start dialog
* Add padding to pdf import dialog
* Add responsive slider
* Highlight primary button in dialogs
* Remove autosave on web

### 1.3.0-beta.1 (2022-04-29)

* Add custom designs
* Add material 3 components
* Add start, update and app introduction dialog
* Add settings to disable start dialog
* Implement pdf import
* Reimplement undo/redo
* Round scale
* Redesigned settings dialog

### 1.3.0-beta.0 (2022-04-20)

* Add svg export
* Add constraints to label and image
* Add horizontal and vertical alignment to label
* Reimplement eraser
* Fixing stroke width

### 1.3.0-alpha.1 (2022-04-12)

* Change scroll behavior to move
    * Add shift to inverse
* Move zoom options and undo/redo in popup menu
* Move overflow menu to the left and replace icon to logo
* Add scrollbar to tools
* Enable share of data for all platforms
* Restructure the code to separate the logic from the UI
* Add an introduction screen for the first start and for a new version
* Fix open file issues when opening by clicking on the file
* Fix full screen
* Temporarily disable undo/redo
* Fix duplicated keybind of insert and export

### 1.3.0-alpha.0 (2022-03-05)

* Add areas
    * Export areas
* Add area painter to declare areas
* Add full screen
* Update flutter version

</details>

## 1.2.1 (2022-03-05)

* Fix label creation
* Fix help links
* Fix move and duplicate in file system dialog

## 1.2.0 (2022-02-22)

* Add baking of the viewport ([#89](https://github.com/LinwoodDev/Butterfly/issues/89))
* Add templates dialogs and presets
* Add change document path option ([#96](https://github.com/LinwoodDev/Butterfly/issues/96))
* Add insert dialog to add simplification of the user interface
  * Add image insert
  * Add camera insert
* Add sensitive settings ([#91](https://github.com/LinwoodDev/Butterfly/issues/91))
* Add background presets
* Add document name editing in the appbar
* Remove image painter in favor of the insert dialog
* Use minSdkVersion 21 instead of 16 (The minimum version of android is 5.0 (Lollipop))
* Move undo/redo button to the left of the appbar

## 1.1.2 (2022-01-21)

* Move color picker in background context menu
* Set the export properties automatically to the current view
* Enable tapping on the expansion panel header to collapse/expand in the background dialog
* Change move window button on desktop to exclude buttons
* Change waypoints shortcut to Ctrl + Shift + P (was Ctrl + W) to avoid conflicts with web browsers
* Change background stroke width relative to the zoom level
* Change initial tool to first tool in the list
* Change alpha to 0.25 for the highlight color
* Fix bug where content gets reset when using the layer tool
* Fix color picker
* Fix label property in painter dialog
* Fix move/duplicate dialog in file system dialog
* Fix color not updating when changing the palette
* Fix waypoint create context
* Fix redo/undo context

## 1.1.1 (2022-01-14)

* Fix image loading ([#83](https://github.com/LinwoodDev/Butterfly/issues/83))
* Fix image hit box
* Reimplement spaces in box background
* Fix box background
* Fix text editing dialog

## 1.1.0 (2022-01-05)

* Add layers to group elements
* Add layer painter to change the layer of the elements
* Add natural zoom
* Add ink well and rounding borders to painter buttons
* Fix open dialog crash when the dialog is closed by the user.

## 1.0.0 (2021-12-24)

* Adding deb and AppImage export type for linux
* Improve responsive file system dialog

<details>
 <summary>1.0 Nightly Changelog</summary>

### 1.0.0-rc.6 (2021-12-18)

* Add context menu
* Add zoom-dependent stroke width ([#31](https://github.com/LinwoodDev/Butterfly/issues/31))
* Move background and waypoints to background context menu
* Move color palette to three points menu
* Fix internal router, use / instead of hash
* Fix responsive issues on color picker, file system and image export

### 1.0.0-rc.5 (2021-12-10)

* Add eraser exclude property for the hand
* Add folder creation feature to the file system
* Add move feature to the file system
* Add search to waypoints dialog
* Add path and search widget to open dialog
* Add hand properties
* Add nightly icon
* Add pwa documentation
* Implement move/duplicate for elements
* Prevent browser behaviors on the web version
* Fixing file system on native platforms
* Fix splash screen on screen readers
* Fix some dialog themes to have rounded corners

### 1.0.0-rc.4 (2021-11-27)

* Add file system with files and folders native and indexeddb in web ([#53](https://github.com/LinwoodDev/butterfly/pull/53))
  * Custom save location
  * Added file names
* Add behavior options for multi gestures ([#45](https://github.com/LinwoodDev/butterfly/issues/45))
* Add version to information dialog ([#50](https://github.com/LinwoodDev/butterfly/issues/50))
* Fixing dialogs will open multiple times ([#47](https://github.com/LinwoodDev/butterfly/issues/47))
* Improve performance for images ([#35](https://github.com/LinwoodDev/butterfly/issues/35))

### 1.0.0-rc.3 (2021-11-14)

* Add shortcuts
* Add default name for documents
* Reimplement fill feature
* Fixing zooming
* Fixing version on windows installer

### 1.0.0-rc.2 (2021-11-07)

* Change home page to drawing page ([#17](https://github.com/LinwoodDev/butterfly/issues/17))
* Fixing zoom issues ([#20](https://github.com/LinwoodDev/butterfly/issues/20))
* Simplify selection ([#23](https://github.com/LinwoodDev/butterfly/issues/23))
  * Add more space to select
  * Add calculation to look if the cursor is between two points
  * Add calculation to get the real width and height of the text
  * Add select dialog if there are more than one element on the position
  * Add box that highlights the selection
* Change old home page to open dialog
* Rename old open dialog to import dialog
* Rename old save dialog to export dialog
* Add popup menu in the top right corner of the main view

### 1.0.0-rc.1 (2021-10-30)

* Add new graphic engine to allow moving in the negative direction
* Big performance issues were fixed
* New loading screen on web
* Add separate color palette class (new color palette file format)
* Fixing empty names in document name ([#14](https://github.com/LinwoodDev/butterfly/issues/14))
* Fixing open/save dialog

### 1.0.0-rc.0 (2021-10-20)

* Add new design system
* Add image painter and layer
  * Add scale property
* Add open/save dialog
* Add letter spacing to text painter and element
* Add internal property class to simplify equal variables on painter and layer
* Normalize json keys
* Fix lag when zooming out of the viewport
* Split custom painter from view internally

### 1.0.0-beta.0 (2021-10-15)

* Add new color picker
  * Multiple palettes
  * Open/save palettes
  * Custom colors
  * Edit palettes
* Add new label properties (font weight, italic, decoration)
* Fix shared preferences bug that prevents starting the app on android

### 1.0.0-alpha.0 (2021-10-10)

First release 🎉

</details>
