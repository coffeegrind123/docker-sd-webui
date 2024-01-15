Words such as extra ______, high quality, masterpiece, ugly ______ are placebos. You can- most of the time- have a completely empty negative prompt and be fine.
Do not use emphasis unless absolutely necessary. (this:1.2), (that:1.3), (here:1.4), (there:1.5) can be detrimental to a prompt.
Do not make your prompts too long; imagine Stable Diffusion has a poor attention span, and writing too many words makes it miss things.
Focus on using e621 tags only if you can, especially when using EasyFluff.

When thinking about increasing the weight on a tag, think about this. A1111 reduces the weight of every other tag so that the average is still 1 - so you aren't really increasing the emphasis, you're decreasing the emphasis of everything else! Keep it to an absolute minimum. There are tags where it's warranted, especially low post count tags, but it's not common
You can end up reducing the weight of tags you want so much they are completely ignored if you go crazy with it
And if everything has increased weight, nothing does - it's getting averaged back to 1 anyways

with generating images it's good to start simple and build up the description
that gives you pretty easy chunks to identify when adding something did nothing
style -> subject -> composition -> details is a pretty decent way to go about it

the resolution the model was trained on is going to be where it performs best, and going significantly above or below that will impact how the results look
for easyfluff, i believe the recommendation is 728x728?
aspect ratio does also have an impact on generations
you'll find that if you generate images in the aspect ratio you would expect to see that concept in, you'll get closer to the result you want

ai generations are gonna pretty unavoidably have artifacts most of the time
if you want something truly good, you can start with generating until you get a decent base, then manually fixing and inpainting the messed up stuff

prompting isn't particularly difficult. basically just type in how you think the e6 image would be tagged lol

inpainting is just a way of selecting a specific portion of an image to be regenerated
inpainting literally regenerates part of the image - it needs the prompt used to make the original image to do smooth edits

you don't have a artist style tag, so you're getting the approximation of every artist on e6 weighted by post count
as interpreted by an ai
which for obv reasons does not look good
take the exact same prompt, add the style tag "by hioshiru" to the end
also, be careful about spelling and be precise

a1111 normalizes prompt weights to 1, so every unnecessary weight added not only has a chance of making that specific output explode but also weakens every other tag in the prompt 
as i said before, do not add weights randomly
weigh things when they a. normally work and b. get overpowered by something else in the context of that prompt
some tags also seem to support different "intensity" at different weights, like slightly chubby, but whether or not the tag you are using does is again something you'll have to check

youd mostly wanna put stuff in the negative that one could consider to be the opposite of what youre prompting, like if you want t generate an image of a female, youd put male in the negative, someone tall, put short in the negative, realistic? put toony, anime, chibi in the negative
front view? put side view and rear view in negative
then you gotta be hip to thigns that could imply other things
like putting butt or ass could imply rear view or side view 

a token is word (or set of words) between two comas

break is for breaking up prompts since it handles about 75 tokens at a time
you can chose to break it up sooner than 75

BREAK is mostly only used to 'organise' your prompt chunks
Mostly just advanced emphasis control

Use commas to separate each tag only
And spaces in place of underscores
So anthro, solo, fluffy, canine penis etc.
tho theres some tags that have (franchise) or (artist) youll want to do (artist) to escape the brackets
oop
\(artist\)
or \(franchise\)

it's really amazing how many things the ai "doesn't understand" that miraculously work when used in the context of inpainting a sketch

And as a addition to inpainting, prompt editing is an extremely powerful tool. It's [words at start of gen:words to swap to:.2] to swap portions of the prompt at a specified percentage (.2 = 20%) or step (:5 = step 5). Not something to mess with until you have prompting in general down, though, but definitely give'r a look at some point.

Amazing for tags that can cause deformation, like "pawpads" can force pawpads to gen even if the paw isn't in a position for that to be possible in. [:pawpads:.25] pretty much solves the issue by not adding pawpads to the prompt until 25% of the way into generation (edited)


from:terraraptor has:image 
