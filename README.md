# mc-input_menu_manager
Library aimed for easy management of input based menus (minecraft 1.21.5)

> [!IMPORTANT]  
> Read carefully this README before starting to work.

 ## Introduction to input menus
An "input menu" is a kind of UI where the players interact with it via movement keys **(WASD, Sprint, Crouch, Jump)**, their usage can vary and their main advantage is the speed at which players can operate them, making them very user-friendly _even while playing with a controller or in mobile_.
 This library works for 2 types of input menus, a **fixed** option, where players can't move their camera, and one that works "**on the spot**". Both support the same input data, which means that you can run the same menu on both types without having to worry about compatibility. It's only issue is visuals, because _on-spot menus can have a different amount of display entities_ depending on how you spawn them (on this version, they have less displays compared to the fixed one for example).
### Fixed menus
To be able to use the fixed option, you'll need to first choose where you want to have it laying around, this means that you'll have to prepare an area for it (if you want to have a nice looking background you may need to dedicate a bit of extra time on this). Once you decide where you want to place it, you'll need to create it. This can be done by running ```/function lmenu:control/create_main_fixed_setup {x:INT,y:INT,z:INT,r1:FLOAT,r2:FLOAT}``` on chat.
> [!NOTE]
> You will need to have the menu chunk loaded at all times in order for players to go there.
> You may also want to have players nearby 1-2 ticks before making them spectate the root.

The menu will be then placed in the floor of the block you selected, spreading all the player spots over the block and all the displays will be rotated using (r1,r2).
> [!TIP]
> This kind of menu is specially good for main menu screens!

> [!CAUTION]
> Remember to set the maximum of players allowed (and different session ids for them).
> You need to re-create the menu after changing those settings.

### On-spot menus
On-spot menus require the minimum effort in order to create them, BUT players should only be able to create them **in controlled scenarios** or you would need to add an extra check on their movement, if they ever move even the smallest amount, they won't be able to see the menu. This means that if you want to create a survival-friendly menu, you'll need to do some homework (warning below). But not everything has to be bad, this menus allow players to interact with the menu by adding an extra layer, their hotbar, the biome they are on, the amount of items they carry... Everything that can happen dynamically can be easily done on them, because players also have control over their character while using them.
> [!CAUTION]
> Remember to set the players id before using this menus.

> [!WARNING]
> To forget about the movement issues, add a check for 0 speed when calling a creation event, a ticking speed check while using it to call the removal of the menu and some extra checks like changing dimensions or taking damage to avoid issues with enderpearls or mobs hitting the player.

> [!TIP]
> This menu type fits best on world interactions! (custom crafting, panel interactions...)

## DATA MANAGEMENT AND REQUIREMENTS
## Installing
First, we need to talk about how to start the library. For that, you have to call the function ```zleinad_pack_manager:load_menu```, why the different namespace and not running it on reload you may ask? to avoid people from making mistakes that are covered here, because they can break your worlds very fast, ***trust me***.
Once you peek inside that function, you'll inmediately see that it needs quite a lot of scores for something so trivial, that is because this library works with multiple ID systems:
- (Player) Permanent ids
- (Entity) Permanent ids
> The permanent ids should be assigned once the entity/player joins the world, also, players SHOULD NOT have an entityID and entities SHOULD NOT have a playerID, in this case, only the player ids can be recycled from outside.
- (Player) Session ids
> Session ids are a bit different from what usual maps use, this are meant to be the usual "player 1, player 2..." indicators usually found on local play, and their purpose is to tell what spot to occupy for the players. This was a strange decision to make because usually, players get their position based on what places are occupied, but here, ensuring their spot is always free means that they can get there faster, which makes the menus lighter on big playercounts while also being able to work well on singleplayer.
- (Entity) Owner ids
- (Entity) Entity type ids
> Owner ids tell the datapack which player summoned which entity, and they work together with the entity-type ids to avoid possible issues with other "owner systems" you may need.

Most of this is usually managed by the maps themselves if you are working on a bigger project, so you can probably replace them by your own scores (be sure that everything is compatible before merging the scores)
If you don't merge the scores, you'll also need to manually set the permanent ids on players for on-spot menus and their session ids for the fixed menu, the easiest way to do this is with player login-logout detection.

> [!NOTE]
> For singleplayer worlds, session id is not strictly required, but I can't ensure that things won't break.

There are also 2 constants related to the player capacity of the menu,  `#max_players` and `#points_per_row`. The first one being the maximum player cap of the menu (how many sessions you can hold without overlapping menus) and the second one how many players go in the same row on the fixed setup. This setup starts at x.0,z.0 of the selected block and gets to the edge on the 8th position, be sure to check out how it's generated (the loop functions) before changing this setting.
## Uninstalling
To uninstall the library you just need to follow 2 steps
- Remove all menus from the world to avoid leaving them hanging
- Run ```/function zleinad_pack_manager:uninstall_menu``` on chat

## Data format
The datapack follows a data path inside the ```menu:data``` storage like this:
> menu:data MAINPATH.SECONDARY.DATA

where MAINPATH is given by the function ```lmenu:control/get_stage``` (needs the main score to work), SECONDARY is an integer stored on the player's secondary score and DATA contains whatever the manager of that menu specifies following the menu format.
> The DATA should be something on the lines of ```{adv_j:1,display_1:{text:"example_text",Tags:["hardchanging_tags_isnot_a_great_idea_btw"]}}```, which will be explained later.

DATA covers 3 aspects of the menu stages:
- Display appearance
> The display appearance is managed in subpaths like `display_1:{ENTITYDATA}`, where ENTITYDATA is the data to **merge** into the display, to add more paths or change the predefined ones, look inside ```lmenu:load_stage``` (fixed) and ```lmenu:on_spot/load_stage``` (on-spot)
- Inputs and target stages
> This part is controlled in subpaths like `adv_L:TARGET_STAGE`, where TARGET_STAGE is the secondary stage to set the player after they pressed the L(etter) key, the possible letters to choose are:
> - **j**ump
> - **s**print
> - **c**rouch
> - **u**p
> - **d**own
> - **l**eft
> - **r**ight
> 
> Each of them calling their corresponding advancement, to change this or their initials, check ```lmenu:stage_changed``` (fixed) and ```lmenu:on_spot/stage_changed``` (on-spot)
- Function to run AFTER starting stage
> This is the function name that the stage calls after setting the data on the displays, by default it completes `$function $(function)`, but it can be changed inside ```lmenu:do_nested_function``` to complete whatever command you may want (to set it to all commands, just leave it like `$$(function)`)

> [!TIP]
> To add your data to the database, put your data function inside the `#lmenu:reload_menus` tag and it will be reloaded on `/reload`!
## Example and further help
There are 2 folders on this repository, one for the library and another one that contains an example of a menu, if you read carefully this wall of text you should be ready to install it in a superflat and test how everything works!
If you find yourself unable to make this work, fell free to message me on discord with your issue ***@leinad677yt***, I'll try to help if I have the time 

-# **I can't ensure that I will be able to help with issues regarding compatibility with other datapacks as I don't know how they will be handling display entities in general**
