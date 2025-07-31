# shamey-book

A free, open-source RedM script for reading books/newspapers/cards

This script covers 3 different types of "reading":
1. **Coordinates-based and job-locked "books"**
   - Essentially: viewing a set of images *at a certain map spot in-game*. We used this for "naturalists"/witches (see [shamey-naturalist](https://github.com/ShameyWinehouse/shamey-naturalist)) to allow players to view a secret "book" with quest info.
   - Note: This type has no prop, animation, etc.

2. **Item-based books, staff-created:**
    - Items created manually by staff in the database, and manually pre-configured in `config.lua` here.
    - *Example: Search `trapper-guide` in `config.lua`*

3. **Item-based books, player-'printed'**
    - Exclusively integrated with [shamey-printing](https://github.com/ShameyWinehouse/shamey-printing)


## Credit
The viewing/reading UI is almost identical to the one I made for [shamey-scene](https://github.com/ShameyWinehouse/shamey-scene), which is an enhacenment of [BryceCanyonCounty/bcc-scene](https://github.com/BryceCanyonCounty/bcc-scene) (Apache 2.0 license). My coordinates-based "books" (type 1) are essentially a variation of a scene, so credit to BCC for that!


## Features
- Read books, newspapers, & cards
- Animations & multiple props (for types 2 and 3)
- Accessibility (click image for alt text)
- Configurable (locations, items, buttons, pages)
- Organized & documented
- Performant

## Requirements
- [VORP Framework](https://github.com/vorpcore)
- [jo_libs](https://github.com/Jump-On-Studios/RedM-jo_libs)
- [shamey-core](https://github.com/ShameyWinehouse/shamey-core) (for job system)
- [shamey-printing](https://github.com/ShameyWinehouse/shamey-core) (for players to generate the items)

## License & Support
This software was formerly proprietary to Rainbow Railroad Roleplay, but I am now releasing it free and open-source under GNU GPLv3. I cannot provide any support.