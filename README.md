                          _.--.
                          ;.-'i.`._.--,
                         {(;{} y`-.`,_`--.
                        <`~;`-( _.'`.~`.' \
                         \  `i.' `  Y  },-,)
                        .j~. |      ;  / _j\
                       <_   `!      ;_.'(  /
                         >-,  `---.,'  .'-j
                        /   `.   ,<_  ( `. \
                        `=-j\ `-
                *         * *
                *       *    *
               <*     *     *
                *    *     *
                *   *     *
                *  *    *
                * *   *
                **  *
                * *
                *
                *
unknown

**DEEP FRYER**

Requires [imagemagick](https://imagemagick.org/script/download.php).

Video support requires [FFMPEG](ffmpeg.org).

required args:
- `-f` image_file (default: spongebob.jpg) 

You can also always add the image file as the last argument without `-f`

optional args:
- `-n` iterations (default: 10)
- `-s` save every (default: 1)
- `-h` history file output (default: history.txt)
- `-r` file to replay (default: null)
  - must be a history file that resulted from deep frying
  - `-n` and `-h` arguments will be ignored
- `-o` output_directory (default: output)
- `-l` only generate last image (default: false. just include -l to turn on)
  - `-n` argument will be ignored

Usage:

    ./deepfry.sh -n 10 -o output_folder -s 1 -f spongebob.jpg
  

By default, deep fry steps will be saved to history.txt. T save elsewhere, use `-h` [filename].
All history is also appended to scratch.txt as a backup in case a good sequence gets lost. 
To replay a history file, supply it with the `-r` flag.

To replay a history file: 

    ./deepfry.sh -r history.txt -o output_folder -f spongebob.jpg

**DEEP FRY A VIDEO**

The `deepfry-video.sh` script requires a .mp4 file and a history file generated while deep frying an image.
You can also optionally provide a framerate. The default is 30 fps. Here's how to deep fry a video at 60 frames per second, saving all generated files in the `video-output` folder:

    ./deepfry-video.sh -r history.txt -fr 60 -o video-output vid.mp4

This script generates individual frames from the video at the specified framerate, saves deep fried versions of each frame following the history file into a `deepfried` subfolder, and recombines those frames back into a video called `out.mp4` in `deepfried`. 

**DEEP FRY DIRECTOR: -d**

Instead of using a single history file to deep fry all frames of a video, you can provide a sequence of history files and specify which frames they apply to using the Deep Fry Director flag, `-d`. This points to a Director Folder. 

A director folder contains: a director.txt file, and a `history` subfolder.
The history subfolder contains any history files referenced by the director.txt file.

The format of the director.txt file is `[history file],[last frame]`:

    history1.txt,999
    history2.txt,1000
    history3.txt,2000
    history4.txt

This file will apply history1.txt to frames 0-999, history2.txt to frame 1000, and history3.txt from frame 1001 to 2000, and history4.txt from 2001 to the very last frame.  

    ./deepfry-video.sh -d ./director -fr 60 -o video-output vid.mp4

> **_Hot tip:_**  to see how many frames are in a video, use the `-fc` flag:
>
>     ./deepfry-video.sh -fc vid.mp4
>     total frames: 150