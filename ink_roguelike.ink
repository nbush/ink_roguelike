// A narrative mini-roguelike written in Ink, meant to be played in Inky.

-> start

/* FUNCTIONS */

=== function is_player_position
~ return (adj_y == ypos && x == xpos)

=== function place_wall
// first condition to prevent placing tile on player
// second condition to prevent blocking player in corner
{not world_generated && not is_player_position() && not (y == 1 && x == 0):
    {&
        - {~ 
            - ~ return false
            - ~ return false
            - ~ return false
            - ~ return false
            - ~ return false
            - ~ return false
            - ~ return true
            }
        - ~ return false
        - ~ return false
        - ~ return false
        - {~ 
            - ~ return false
            - ~ return true
            - ~ return true
            }
        - ~ return false
    }
- else:
    ~ return false
}

=== function place_item
{not world_generated && items_placed < 3 && not is_player_position():
    {~ 
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ return false
        - ~ items_placed++
            ~ return true
    }
- else:
    ~ return false
}

=== function redraw_tile
{
    - list_check(y_1,y_2,y_3,y_4,y_5,x,y):
        ~ return wall_tile
    - list_check(item_1,item_2,item_3,item_4,item_5,x,y):
        ~ return item_tile
    - is_player_position():
        ~ return player_tile
    - else: 
        ~ return empty_tile
}

=== function list_check(list1,list2,list3,list4,list5,x_val,y_val)
// LIST_RANGE because you can't use list(x) notation in a function
~ temp z = x_val+1
{
    - y_val == 0 && list1 has LIST_RANGE(list1, z, z):
        ~ return true
    - y_val == 1 && list2 has LIST_RANGE(list2, z, z): 
        ~ return true
    - y_val == 2 && list3 has LIST_RANGE(list3, z, z): 
        ~ return true
    - y_val == 3 && list4 has LIST_RANGE(list4, z, z): 
        ~ return true
    - y_val == 4 && list5 has LIST_RANGE(list5, z, z): 
        ~ return true
    - else:
        ~ return false
}

=== function update_list(ref list1, ref list2, ref list3, ref list4, ref list5, x_var, y_var, is_add)
~ temp z = x_var+1
{ is_add:
    - 
        // adding element to list
        {
            - y_var == 0: ~ list1 += LIST_RANGE(list1, z, z)
            - y_var == 1: ~ list2 += LIST_RANGE(list2, z, z)
            - y_var == 2: ~ list3 += LIST_RANGE(list3, z, z)
            - y_var == 3: ~ list4 += LIST_RANGE(list4, z, z)
            - y_var == 4: ~ list5 += LIST_RANGE(list5, z, z)
        }
    - else: 
        // removing element from list
        {
            - y_var == 0: ~ list1 -= LIST_RANGE(list1, z, z)
            - y_var == 1: ~ list2 -= LIST_RANGE(list2, z, z)
            - y_var == 2: ~ list3 -= LIST_RANGE(list3, z, z)
            - y_var == 3: ~ list4 -= LIST_RANGE(list4, z, z)
            - y_var == 4: ~ list5 -= LIST_RANGE(list5, z, z)
        }    
}

=== function get_floor_type
~ temp chosen_floor = LIST_RANDOM(floor_types)
~ floor_types -= chosen_floor
~ return chosen_floor

=== function energy_change(change)
You <>
{ 
    - change < 0:
        lose {change * -1} <>
    - change > 0:
        gain {change} <> 
}
energy.
~ energy += change

// stolen Inkle functions
=== function LIST_RANDOM(list) 
    { list:
        ~ return getNth(list, RANDOM(1, LIST_COUNT(list)))
    - else:
        ~ return list 
    }
 
=== function getNth(list, n) 
    { LIST_COUNT(list) > 0:
        ~ n = n mod LIST_COUNT(list)
        { n <= 0:
            ~ return LIST_MIN(list) 
        - else: 
            ~ return getNth(list - LIST_MIN(list), n - 1)
        }
    }

=== function listWithCommas(list, if_empty) 
    {LIST_COUNT(list): 
    - 2: 
        	{LIST_MIN(list)} and {listWithCommas(list - LIST_MIN(list), if_empty)}
    - 1: 
        	{list}
    - 0: 
			{if_empty}	        
    - else: 
      		{LIST_MIN(list)}, {listWithCommas(list - LIST_MIN(list), if_empty)} 
    }

/* GAME */

=== game
= init
VAR wall_tile = "&\#9608;️"
VAR item_tile = "?"
VAR player_tile = "@"
VAR empty_tile = "&\#9617;️"

VAR world_generated = false

VAR world_width = 10
VAR world_height = 5
VAR adj_y = 0

// player position
VAR xpos = 0
VAR ypos = 0

// initialize tile generation counters
VAR x = 0
VAR y = 0

// tracked stats
VAR floor_type = "none"
VAR floor = 1
VAR energy = 50
VAR all_found = false

// get randomized floor type
~ floor_type = get_floor_type()

// items
VAR items_placed = 0
VAR items_identified = 0
VAR stairs_x = "error"
VAR stairs_y = "error"

// walls
LIST y_1 = a,b,c,d,e,f,g,h,i,j
LIST y_2 = a,b,c,d,e,f,g,h,i,j
LIST y_3 = a,b,c,d,e,f,g,h,i,j
LIST y_4 = a,b,c,d,e,f,g,h,i,j
LIST y_5 = a,b,c,d,e,f,g,h,i,j

// items
LIST item_1 = a,b,c,d,e,f,g,h,i,j
LIST item_2 = a,b,c,d,e,f,g,h,i,j
LIST item_3 = a,b,c,d,e,f,g,h,i,j
LIST item_4 = a,b,c,d,e,f,g,h,i,j
LIST item_5 = a,b,c,d,e,f,g,h,i,j

// item types
LIST spills_found = (pennies), (broadbeans), (rivets), (chili), (Gatorade)
LIST children_found = (Orville), (Yulia), (Diego), (Sanri), (Kenneth)

// floor types
LIST floor_types = (money), (legumes), (fasteners), (lunch), (sports)

TODO debug
// clear lists
~ spills_found = ()
~ children_found = ()

-> draw_world

= reset_lists
    ~ y_1 = ()
    ~ y_2 = ()
    ~ y_3 = ()
    ~ y_4 = ()
    ~ y_5 = ()
    
    ~ item_1 = ()
    ~ item_2 = ()
    ~ item_3 = ()
    ~ item_4 = ()
    ~ item_5 = ()
->->

= draw_world
    // introduce the floor if new
    {not world_generated:
        -> floor_text ->
    }
    
    // clear counters
    ~ x = 0
    ~ y = 0
    
    - (gen_y)
        // reset x for new row
        ~ x = 0
        
        { y == world_height: -> generation_complete}
        
        &nbsp; <>
        
        -> gen_x ->
        - (x_done)
        
        &nbsp;
        
        ~ y++
        -> gen_y
        
    - (gen_x)
        { x == world_width: -> x_done}
        
        // adjusting y for Ink printing "upside down"
        ~ adj_y = (world_height - 1) - y
        
        // draw tile types
        { not world_generated:
            // generate initial tiles
            {
                - place_wall():
                    -> y_list_update("wall") ->
                    {wall_tile}<>
                - place_item():
                    -> y_list_update("item") ->
                    {item_tile}<>
                - is_player_position():
                    {player_tile}<>
                - else:
                    {empty_tile}<>
            }
            - else: <>{redraw_tile()}<>
        }
        
        ~ x++
        -> gen_x
->->

= y_list_update(type)
    {
        - type == "wall":
            {update_list(y_1,y_2,y_3,y_4,y_5,x,y,true)}
        - type == "item":
            {update_list(item_1,item_2,item_3,item_4,item_5,x,y,true)}
    }
->->

= generation_complete
    // world generation complete
    ~ world_generated = true
    
    Energy: {energy}
-> player_action

= player_action
    + [left]
        ~ xpos--
        -> collision_check("l") ->
    + [up]
        ~ ypos++
        -> collision_check("u") ->
    + [right]
        ~ xpos++
        -> collision_check("r") ->
    + [down]
        ~ ypos--
        -> collision_check("d") ->
    + [look around]
        -> think_text ->
- (action_over) -> draw_world

= find_stairs 
    ~ stairs_x = xpos
    ~ stairs_y = ypos
    -> stair_text.find ->
    - (choices)
    + [Climb the stairs.]
        -> ascend
    + [Keep exploring.]
        -> game.player_action.action_over

= ascend
    -> reset_lists ->
    ~ world_generated = false
    
    // reset item generation
    ~ items_placed = 0
    ~ items_identified = 0
    
    // reset stair position
    ~ stairs_x = "error"
    ~ stairs_y = "error"
    
    // update floor num and type
    ~ floor++
    ~ floor_type = get_floor_type()
    
    // generate new floor
    -> draw_world
->->

= restart
In Inky, you'll need to use the "Restart story" button on the top right. Click it now!
-> END

=== collision_check(dir)
    - (world)
    // check world out-of-bounds
    { 
        - xpos < 0:
            ~ xpos = 0
            -> oob_text
        - ypos < 0:
            ~ ypos = 0
            -> oob_text
        - xpos > world_width-1:
            ~ xpos = world_width-1
            -> oob_text
        - ypos > world_height-1:
            ~ ypos = world_height-1
            -> oob_text
    }
    -> wall

    - (wall)
    // check wall collision
    {
        - list_check(y_5,y_4,y_3,y_2,y_1,xpos,ypos):
            -> dir_checker(dir) ->
         - else:
            -> move_success
    }

    - (move_success)
    // lose energy for moving
    ~ energy--
    {energy < 1: -> dead.energy}
    -> stairs
    
    - (stairs)
    // check stairs collision if already identified
    { xpos == stairs_x && ypos == stairs_y:
        -> stair_text.return -> game.find_stairs.choices
    }
    -> item

    - (item)
    // check item pickup
    {
        - list_check(item_5,item_4,item_3,item_2,item_1,xpos,ypos):
            -> pickup_item ->
        - else:
            // no item
            -> move_text ->
    }
    ->->
    
    - (pickup_item)
    // ensure there are stairs on every floor
    {items_identified == 2:
        -> game.find_stairs
    }
    {~
        - // identify stairs
        {stairs_x == "error": 
            -> game.find_stairs
        - else: // reroll if stairs already found
            -> pickup_item
        }
        - -> find_item -> remove_item
        - -> find_item -> remove_item
    }
    
    - (remove_item)
    {update_list(item_5,item_4,item_3,item_2,item_1,xpos,ypos,false)}
    -> game.player_action.action_over

= dir_checker(dir)
    -> wall_text ->
    // resetting player pos after collision
    {dir:
        - "l": ~ xpos++
        - "u": ~ ypos--
        - "r": ~ xpos--
        - "d": ~ ypos++
    }
-> game.player_action.action_over

/* TEXT */

=== start
The Dark Aisle: A Retail Roguelike

The sliding doors glide shut for the final time and you slide the vertical deadbolt shut to seal it for the night. 
Cost Company's main entrance is at the lowest level of Dungeon Mall, one of the biggest shopping centres in the country. Although the store is fully five stories, you are the only clerk on duty. You must complete a full sweep of the store and exit through the secondary entrance on the top floor.
As usual, you expect to find spills and lost children. It's the same every night. And since you're only human, you don't have infinite energy for this unpaid overtime. Let's hope you make it home.
* [Time to go.]
- With only the dim overnight fluorescents, most people would have trouble finding their way through the tall shelves. You, however, have memorized Cost Company's shifting floorplans and are able to visualize them in a two-dimensional grid in your mind.
    With one exception: you suffer from severe scalaria, a condition where you forget the location of stairs. Unfortunately, it makes your job much more difficult.
* [You will overcome.]
    -> game.init
    
=== floor_text
{floor > 1 && floor < 6: You ascend to <>}
{floor:
    - 1: 
    The first floor sells {floor_type}. 
    - 2: the second floor, known for its {floor_type}.
    - 3: floor three, where everyone gets their {floor_type}.
    - 4: the fourth floor, home of {floor_type}.
    - 5: the fifth and final floor, also known as the "{floor_type} floor".
    - 6: -> win
}
->->
    
=== move_text
{ energy == 5:
Your feet drag. You won't be able to go much further.
->->
}
{~ 
    -
    -
    - -> move ->
    -
    - -> event ->
}
->->
= move
{~
    - You move into the next unoccupied space in your mental grid.
    - You take a cartesian step.
    - You take one long stride to minimize steps and extend the longevity of the tread of your expensive work shoes.
    - The electric hum of the lights amplify briefly in the darkness.
    - You catch your diffused reflection in a glass display.
    - The sound of an aging camera survomotor whizzes somewhere on the ceiling.
    - {LIST_COUNT(children_found) > 0: You feel reassured by the sound of gentle footsteps behind you.}
}
->->

= event
{& 
    - -> spill -> 
    - -> child ->
}
->->

- (spill)
{not spills_found: -> child}
{event_pennies && event_broadbeans && event_rivets && event_chili && event_gatorade: ->->}
~ temp ran_spill = LIST_RANDOM(spills_found)
{ran_spill:
    - spills_found(1): 
        {event_pennies: -> spill}
        -> event_pennies
    - spills_found(2): 
        {event_broadbeans: -> spill}
        -> event_broadbeans
    - spills_found(3): 
        {event_rivets: -> spill}
        -> event_rivets
    - spills_found(4): 
        {event_chili: -> spill}
        -> event_chili
    - spills_found(5): 
        {event_gatorade: -> spill}
        -> event_gatorade
}
- (event_pennies)
    A sharp metallic note floats into your nostrils, no doubt from the penny residue. You remind yourself that Canadian pennies are only five percent copper, although you secretly doubt that to be true.
    -> event_over
- (event_broadbeans)
    You finally determine that the microdisturbance in your gait is from a rogue broadbean pea lodged in the tread of your skid-free work shoes. You lift your foot to find not one but three squashed peas staring at you in agony. You try to pry them off as delicately as possible and fling them in the trash.
    -> event_over
- (event_rivets)
    You reflexively run your fingers together in an attempt to remove the oily film left over from the freshly-pressed rivets. You ponder the intense shearing force of pressing metal, even for the tiniest pieces of hardware, compared to the fragility of your human hands.
    -> event_over
- (event_chili)
    You've been trying for the last ten minutes to identify the makeup of the spilled chili. It's the only way to reckon with the lingering scent that remains on your hands. It's definitely beef, and you've narrowed it down to either Hearty Brisket or Roadhouse, but further specification feels impossible.
    -> event_over
- (event_gatorade)
    You scratch your nose and smell the sodium tang of Gatorade Cool Blue. You are marked by electrolytes, and you feel them buzz on your skin.
    -> event_over
- (event_over)
+ [OK.]
- ->->

- (child)
{not children_found: ->->}
{event_orville && event_yulia && event_diego && event_sanri && event_kenneth: ->->}
~ temp ran_child = LIST_RANDOM(children_found)
{ran_child:
    - children_found(1): 
        {event_orville: -> child}
        -> event_orville
    - children_found(2): 
        {event_yulia: -> child}
        -> event_yulia
    - children_found(3): 
        {event_diego: -> child}
        -> event_diego
    - children_found(4): 
        {event_sanri: -> child}
        -> event_sanri
    - children_found(5):
        {event_kenneth: -> child}
        -> event_kenneth
}
- (event_orville)
    Orville runs in front of you and turns around, adopting a defiant posture.
        "Where is everyone?"
        * [Think about answering.]
            But before you can answer, he continues:
            {children_found ? Kenneth:
            "Kenneth was wondering."
            You look at Kenneth, who shakes his head vigorously.
            You're not quite sure what to say, so you say nothing.
            - else:
            "I'm sorry. Let's keep going. Just... make sure you don't leave me behind."
            }
    -> event_end
- (event_yulia)
    You notice Yulia staring at the shelves, focusing intensely on certain items. She begins to whisper to herself:
    "так много сделок..."
    She looks at her feet in resignation before continuing in a disappointed voice.
    "но мы не получим никаких очков, если мы купим сейчас."
    -> event_end
- (event_diego)
    You hear a loud crash and immediately turn around to see Diego sprawled on the floor. <> 
    {children_found ? Sanri:
    Sanri, unamused, steps over his body to catch up. <> 
    }
    He speaks from the ground.
    "I ran into something. It's so dark in here."
    He scrambles back to his feet.
    By the sound of it, he must have actually sprinted into a shelf. 
    "I'm OK. I'm going to follow you from now on so I don't hit anything else."
    -> event_end
- (event_sanri)
    You hear a muffled clicking behind you. It morphs into a rapid syncopation of crisp wood block percussion as Sanri unearths her ringing phone. It is quickly silenced without being answered.
    You want to say something, but Sanri's silence is contagious. The store that you know so well feels full of new ears.
    {children_found ? Diego:
    Diego appears unperturbed, anxious as ever to move on.
    }
    -> event_end
- (event_kenneth)
    "Wait!"
    You spin around and see Kenneth with his hands out, as if trying to keep balance during a tremor. Suddenly, he raises his hands up and produces the loudest sneeze you've ever heard, simultaneously pumping his arms downwards like a cross-country skier. It's an impressive sequence.
    {children_found ? Orville:
    For some reason, you look expectantly at Orville. He remains silent, but his arms are flung behind him as if he mimicked the sneeze in silent solidarity. He catches your eye at resumes his typical strict posture.
    }
    -> event_end
- (event_end)
+ [OK.]
- ->->

=== oob_text
{~
    - You smack into a fake window with a vinyl sticker showing a green mountain landscape and solid grey clouds.
    - You run into a bare wall.
    - You hit a wall you should have seen. You're usually pretty good at detecting walls.
    - You try to walk out of the building entirely, but are stopped by a sturdy wall.
}
-> game.player_action.action_over

=== wall_text
You {~ run|bump|careen|smash|walk} into <>
{ floor_type:
    - floor_types(1): 
        // money
        {~ 
            - a shelf full of crisp Thai baht notes.
            - a display selling dollars.
            - a astrology-themed coin press.
            - a gumball machine filled with dimes.
            - a six-foot tall plastic anthropomorphized dollar sign.
        }
    - floor_types(2): 
        // legumes
        {~ 
            - a carefully stacked pyramid of peas.
            - a lush collection of hanging soybean clusters.
            - an animatronic lentil. 
            - a wall covered with gravity-assisted dried bean dispensers and plastic bean-patterned catching bags.
        }
    - floor_types(3):
        // fasteners
        {~ 
            - a wall of plastic quickties.
            - a clothespin display rack.
            - a Robertson club signup sheet.
            - a selection of flanges.
            - a wall covered in Velcro, which you bounce off harmlessly in your mandated Velcrophobic work attire.
            - tubes full of dowels of various diameters. 
        }
    - floor_types(4):
        // lunch
        {~ 
            - a sandwich display.
            - a soup fountain.
            - a shelf full of chips.
            - a brunch informational kiosk.
            - a misted Alfalfa sprout refrigerator. 
            - assorted copper mustard taps.
        }
    - floor_types(5):
        // sports
        {~ 
            - a custom jersey loom.
            - a stack of deflated Molten soccer balls.
            - vertical jump improvement brochures.
            - assorted rulebooks.
            - shelves full of chess clocks.
            - hanging squash goggles.
        }
}
->->
    
=== think_text
{LIST_COUNT(spills_found):
    - 0:
    You {think_text > 1: still} haven't found any spills. Your hands are {think_text > 1: still} clean.
    - 1:
    You feel the residue of {spills_found} on your fingers.
    - else:
    You feel the residue of {listWithCommas(spills_found,"error")} on your fingers.
}
{LIST_COUNT(children_found): 
    - 0:
        You {think_text > 1: still} haven't found any lost children, but you {think_text > 1: still} know they're out there.
    - 1: 
        {children_found} dodders behind you, somehow as focused as you are on exiting the store.
    - else:
        {listWithCommas(children_found,"error")} dodder behind you. Their expressions are hard to identify in the darkness.
}
->->
    
=== find_item
~ items_identified++
You found <>
{&
    - -> found_spill ->
    - -> found_child ->
}
->->

= found_spill
a spill! <>
{ floor_type:
    - floor_types(1): 
        // money
        {~ 
            - -> found_pennies -> 
        }
    - floor_types(2): 
        // legumes
        {~ 
            - -> found_broad -> 
        }
    - floor_types(3):
        // fasteners
        {~ 
            - -> found_rivets -> 
        }
    - floor_types(4):
        // lunch
        {~ 
            - -> found_chili -> 
        }
    - floor_types(5):
        // sports
        {~ 
            - -> found_gatorade -> 
        }
}
->->

- (found_pennies)
    ~ spills_found += pennies
    In front of you stand three stacks of dirty Canadian pennies. The dark tarnished copper and green patina patches makes the stacks look like tree trunks covered in lichen.
    You try to pick up the stacks as whole units but your fingernail gets caught on the lowest penny, causing the whole arrangement to collapse and roll away. It takes you a while to collect all the pennies.
    {energy_change(-5)}
->->

- (found_chili)
    ~ spills_found += chili
    The smell of cumin fills the air. Someone tried to open a can of chili and it spilled all over the floor. They even left the can opener.
    You clean it up, but lacking proper detergent a greasy ring is left on the floor. As you step back you can't help but notice the almost perfect circle formed by the chili spill.
    {energy_change(-2)}
->->

- (found_broad)
    ~ spills_found += broadbeans
    It's a mound of broadbeans. Upon closer inspection, the've all bean de-strung. You've seen this before: lots of people use bean strings tied around fingers to remind themselves to eat more vegetables. Such a waste, though.
    You kick them under the shelf for the mice to eat.
    {energy_change(-1)}
->->

- (found_gatorade)
    ~ spills_found += Gatorade
    Someone has dumped the entire orange Gatorade dispenser again. There's a coach-sized area on the ground in the middle of the spill where someone must have stood under the syrupy deluge. 
    You can smell the colour and are reminded of the drink's artificial synesthesia, teaching drinkers what the colour blue tastes like. But mostly athletes. Synathlesia... synesthathletes... synesthestics... synathletics.
    These are your thoughts as you wipe the floor clean. 
    {energy_change(-4)}
->->

- (found_rivets)
    ~ spills_found += rivets
    There are exactly six rivets on the floor in the centre of the aisle, arranged in a pattern. It looks like someone was trying to write something in rivets but lost interest. There's a pun in there somewhere.
    You pick them up and put them back on the rivet shelf.
    {energy_change(-1)}
->->

= found_child
a lost child! You approach with <>
{energy > 10: 
    {& an empathetic| an earnest| a cautious| a friendly} <> 
- else: {& a tired| an exhausted} <>
} look on your face.
{ floor_type:
    - floor_types(1):
        {~ 
            - -> found_orville -> 
        }
    - floor_types(2): 
        {~ 
            - -> found_yulia -> 
        }
    - floor_types(3):
        {~ 
            - -> found_diego -> 
        }
    - floor_types(4):
        {~ 
            - -> found_sanri -> 
        }
    - floor_types(5):
        {~ 
            - -> found_kenneth -> 
        }
}
->->

- (found_orville)
~ children_found += Orville
"My name is Orville."
* [Hello Orville. Are you lost?]
    "No, I know my way out. But I'm not supposed to go alone."
        ** [That's what they say. But you're not alone anymore!]
            "I guess so."
            But he doesn't sound convinced.
            {energy_change(4)}
            -> exeunt_orville
        ** [Are you waiting for someone?]
            "Well... maybe."
            That's good enough for you, and you reply with a nod.
            {energy_change(5)}
            -> exeunt_orville
* {children_found ? Kenneth} [Ah, we found you!]
    "Kenneth! I knew you'd find me! I knew you wouldn't leave without me!"
    They look at each other and smile. 
    {energy_change(10)}
- (exeunt_orville)
Orville does some kind of motion with his hand, either a salute or an abbreviated bow. He awaits your next move.
->->

- (found_yulia)
~ children_found += Yulia
The tall girl bows.
"Меня зовут Yulia! Здравствуй!"
Whatever kind of introduction it was, it seemed very polite.
{energy_change(4)}
- (exeunt_yulia)
{children_found ? Sanri:
    Sanri steathily removes her phone and types feverishly for a few seconds. She stops, mumbles silently to herself before hiding the phone once again.
}
Yulia looks as if she'll follow if you start moving. Only one way to find out.
->->

- (found_diego)
~ children_found += Diego
"Hello. My name is Diego. I have been here for so long."
* [Where are your parents?]
    "At home with the fasteners. It isn't the first time."
    ** [That's sad.]
        "I know. Just take me to a phone and I'll find my way back."
        You've never heard such urgency from so young a child, and it gives you energy.
        {energy_change(5)}
        -> exeunt_diego
    ** [This has happened before?]
        "Yes. My sister is a gust of wind. My parents keep trying to keep her in one place, but nothing seems to work. But I have no problem staying put."
        *** [Apparently not.]
            "But now I'd like to go home. All I need is a phone."
            You start to shake your head to show that you are phoneless, but Diego seems to know that already.
            {energy_change(3)}
            -> exeunt_diego
* [Tell me about it. Let's go.]
    "I know my phone number. Just get me to a phone please."
    He sounds serious.
    {energy_change(2)}
    -> exeunt_diego
- (exeunt_diego)
{children_found ? Sanri:
Sanri looks up at you, worried. You remain silent.
}
Diego starts ahead of you, thinks better of it, and gets in line.
->->

- (found_sanri)
~ children_found += Sanri
You see a small girl sitting cross-legged, staring at a phone. She says exactly one word:
"Sanri."
    * [Hi, time to go.]
        Sanri stands up without looking from the device, and then abruptly hides it in her long dress and stares at you with a familiar intensity.
        {energy_change(5)}
        -> exeunt_sanri
    * [You have a phone?]
        She shrugs.
        {energy_change(2)}
        -> exeunt_sanri
- (exeunt_sanri)
{children_found ? Diego:
You look at Diego, but he stares impassively down the aisle as if he hadn't noticed Sanri or her phone. 
}
You feel compelled to move.
->->

- (found_kenneth)
~ children_found += Kenneth
"Who are you? I'm Kenneth."
* [Hi, Kenneth.]
    "I'm all ready to go. We don't need to wait."
    ** [That's an odd thing to say.]
        "Why, what are you waiting for? There's no-one else here that I care about. My Dad is already gone, I know that. It's time for me to go home."
        *** [I guess so.]
            {energy_change(2)}
            -> exeunt_kenneth
        *** [What's up, Kenneth? You can tell me.]
            Kenneth jumps at the invocation:
            "My brother is here too!" 
            And then, weakly, "But I'd rather leave without him."
            **** [Well, I think we should find him.]
                "You're probably right. Let's make sure we find him, please."
                {energy_change(2)}
                -> exeunt_kenneth
            **** [If you say so, let's go.]
                The young boy gives you an odd look.
                {energy_change(3)}
                -> exeunt_kenneth
    ** [OK, follow me.]
        {energy_change(3)}
        -> exeunt_kenneth
* {children_found ? Orville} [Your brother's here, Kenneth.]
    "Hi Orville. Glad to see you again."
    They look at each other and smile. <>
    {energy_change(10)}
    -> exeunt_kenneth
- (exeunt_kenneth)
Kenneth gets in line and you continue on.
->->

=== stair_text
= return
You return to the stairs.
->->

= find
<> {~
    - You run into a set of stairs.
    - You run into an empty set of shelves leaning at a crazy angle. Upon closer inspection, it appears you've run into a set of stairs.
    - You find the stairs to the next floor.
}
->->

=== dead 

= energy
You've had enough. You fall asleep in the dark aisle of <>
{ floor_type:
    - floor_types(1): {floor_type}.
    - floor_types(2): {floor_type}.
    - floor_types(3): {floor_type}.
    - floor_types(4): {floor_type}.
    - floor_types(5): {floor_type}.
}
{ children_found:
You don't know if {listWithCommas(children_found,"error")} will be there when you wake up, but there's nothing more you can do.
}
{ spills_found:
The last thing you remember is the smell of {LIST_RANDOM(spills_found)}.
}
+ [Try again.]
-> game.restart

=== win
The fresh air of the open street greets you as you exit Cost Company and Dungeon Mall completely.
- (children)
{LIST_COUNT(children_found) == 5:
    ~ all_found = true
}
{children_found ? Sanri:
    {children_found ? Yulia:
        Out of nowhere you hear an urgent scream:
        "бег! не оставайся здесь!"
        It's Sanri, who gets a shocked look from Yulia before breaking into a sprint. She staggers once, looking back in hesitation. You follow her with your eyes as she disappears into the city.
        ~ children_found -= Yulia
    }
    You hear a clack on the pavement and turn around. Sanri is gone, but her phone is lying face-down on the ground.
    ~ children_found -= Sanri
    {children_found ? Diego:
        Diego lunges for the phone and sprints off down the road. Moments later you hear his excited greeting in the distance in a language you do not understand.
        ~ children_found -= Diego
    }
} 
{children_found ? (Kenneth,Orville):
    Before you can say anything, Kenneth and Orville walk away briskly, holding hands, not looking back.
    ~ children_found -= (Kenneth,Orville)
} 
{LIST_COUNT(children_found): 
    - 0:
        You are all alone. A familiar police cruiser glides by, on schedule, but collects no one. {all_found: You feel an odd sense of satisfaction.}
        -> spills
    - 1: 
        You are still followed by {children_found}, who looks longingly into the darkness. 
    - else:
        You are still followed by {listWithCommas(children_found,"error")}, who look longingly into the darkness. <>
}
On schedule, Officer Madeline approaches. You can't help but notice {LIST_RANDOM(children_found)} grimace at the thought of riding in the cruiser again. Poor kid. You offer a tired smile and wave goodbye.

    Finally alone, you breathe a sigh of relief. <>
- (spills)
In the blue light of the streetlamp, you look down at your hands and <>
{LIST_COUNT(spills_found):
    - 0:
    notice you've emerged from work with clean hands. Quite an accomplishment! -> end
    - 1:
    see unmistakable traces of {spills_found} on your fingers. <> 
    - else:
    see unmistakable traces of {listWithCommas(spills_found,"error")} on your fingers. <>
}
It's a messy reminder of all the work you've done today. You'll have to wash thoroughly when you get home. 
- (end)
But you can finally go home.
{not all_found:
Something, however, bothers you. Officer Madeline's cruiser sticks out unpleasantly in your mind. Maybe you missed something? 
}
-> END