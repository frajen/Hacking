Title: The Elemental Display
Author: Lenophis
Version: v1.1
Applies to: FF3us v1.0, v1.1
Tested on: FF3us v1.0, briefly on v1.1

Contents: Tweak - Elemental - header.ips
          Tweak - Elemental - no header.ips
          Anti Elemental - header.ips
          Anti Elemental - no header.ips
          readme.txt
          elemental - orig.txt
          elemental - new.txt

ROM addresses: C3/88CE - C3/8926
               C3/8DF1 - C3/8E19

Urgency: Medium, depending... The "issue" if you could call it that was a
cosmetic one.

--------------------------------------------------------------------------------
Description:
When you double click on an item to view it's properties, any elemental
properties as well as its stats and who can equip it pop up. When one category
for an element needs to display more than 6 elements, it cuts off after 6.

--------------------------------------------------------------------------------
What this patch does:
It re-arranges that menu a little so that there's room for all 8 elements to be
displayed per category. It also displays up to 8 elements, the maximum allowed.

--------------------------------------------------------------------------------
Versions:

v1.1 - June 11 2007
       No changes made to patch, added non/header patches and anti's.

v1.0 - Initial release

--------------------------------------------------------------------------------
Credits:

Imzogelmo - Writing the C3 bank disassembly.
Yousei - Coming up with the insane menu position formula that eventually
         led to this patch's existance.
