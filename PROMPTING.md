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

Regarding negatives, my advice would be to have it completely empty and then add tags you don't want to see when you start to notice in the images, because a lot of negatives you have now don't really help that much 

im not going to explain the specifics of classifier free guidance, but in essence the negative prompt is a way of hijacking the cfg system to tell the model what to generally drift away from during inference
not what to not do, what to sort of... drift away from

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

there's prompt schedule stuff 
[this:10] does not use the tag until after 10 steps have completed
[this::10] uses the tag for 10 steps but not any more after 

Also don't use weights as high as 1.5 unless it is an extremely obscure tag and you've tried it at a more reasonable weight in the 1.05 - 1.2 range.
Pushing the embedding that far away from the centroid does not intensify the meaning. It starts to lose meaning and just scramble things.

Quick question - does the (token:1.5) syntax work for groups of tokens? (token1, token2:1.5)
yes, but it's gonna push the whole segment up, including commas
we use them as separators, but they mean nothing, and their behavior when being pushed up is not really defined
it can work fine, it can destroy the whole image, depends on the model
(token1:1.5), (token2:1.5) 
same as
(token1,token2:1.5)?
no because in the first one you have 2 independent things being put at 1.5, in the second one you have token1,token2 as a whole being put at 1.5


from:terraraptor has:image 






Using BREAK is literally just 'deciding' where the chunk borders are
Unless your prompt is under 75 tokens
Understand how each chunks weighs against another and how it affects your emphasis

I thought I was supposed to use the BREAK after every 75 tokens
It'll do that automatically if you don't
But doing it manually can prevent concepts being fragmented
A1111 by default moves anything within 20 tokens to the next chunk to prevent this
Which is why sometimes the token count seems to 'skip'


Are token's prioritized by weight across all chunks, or for each specific chunk?
I guess, put another way, are all the chunks evaluated at the same time? 

Good question, all I know is that weights get normalised across the whole prompt
Understand how each chunks weighs against another and how it affects your emphasis
But each chunk also has equal power
I'd you have one tag on its own in a chunk it'll be more impactful than each individual tag in another chunk

Then there's the whole 'tags towards the front are more powerful than those towards the back'... It's complicated to stay consistent

I was using breaks as a way to thematically separate topics.
(all my subject tokens)
BREAK 
(all my environment/scene tokens)
BREAK
(all my "view" tokens)

Yeah that's a good practice generally
Keeping all your 'composition' related tags in one chunk means it's much harder to break
And style in another
which I guess also helps a heavy "character detail" chunk from overpowering all your environment and compositional chunks.

In general it's good to try and learn with just prompts <75
If you don't go over it at all it never gets complicated
