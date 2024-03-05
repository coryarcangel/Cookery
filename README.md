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

**COOKERY**

Requires [imagemagick](https://imagemagick.org/script/download.php).

Video support requires [FFMPEG](ffmpeg.org).

required args:
- `-f` image_file (default: spongebob.jpg) 

You can also always add the image file as the last argument without `-f`

optional args:
- `-n` iterations (default: 5)
- `-s` save every (default: 1)
- `-h` history file output (default: history.txt)
- `-r` file to replay (default: null)
  - must be a history file that resulted from cooking
  - `-n` and `-h` arguments will be ignored
- `-o` output_directory (default: autogenerated based on date/time)
- `-l` only generate last image (default: false. just include -l to turn on)
  - `-n` argument will be ignored

Usage:

    ./cook.sh -n 10 -o output_folder -s 1 -f spongebob.jpg
  

By default, cooking steps will be saved to history.txt. T save elsewhere, use `-h` [filename].
All history is also appended to scratch.txt as a backup in case a good sequence gets lost. 
To replay a history file, supply it with the `-r` flag.

To replay a history file: 

    ./cook.sh -r history.txt -o output_folder -f spongebob.jpg

**COOK A VIDEO**

The `cook-video.sh` script requires a .mp4 file and a history file generated while cooking an image.
You can also optionally provide a framerate. The default is 30 fps. Here's how to cook a video at 60 frames per second, saving all generated files in the `video-output` folder:

    ./cook-video.sh -r history.txt -fr 60 -o video-output vid.mp4

This script generates individual frames from the video at the specified framerate, saves cooked versions of each frame following the history file into a `cooked` subfolder, and recombines those frames back into a video called `out.mp4` in `cooked`. 

**COOKERY DIRECTOR: -d**

Instead of using a single history file to cook all frames of a video, you can provide a sequence of history files and specify which frames they apply to using the Cookery Director flag, `-d`. This points to a Director Folder. 

A director folder contains: a director.txt file, and a `history` subfolder.
The history subfolder contains any history files referenced by the director.txt file.

The format of the director.txt file is `[starting frame],[required history file #1],[optional history file #2]`:

    1,history1.txt
    200,history2.txt,history3.txt
    800,history3.txt

This file will apply history1.txt to frames 1-199. 
Then from frame 200-799, history2.txt will be applied with decreasing strength, while history3.txt will be applied with increasing strength. This achieves a keyframe-like effect.
Then history3.txt will be applied from frame 800 to the final frame.

    ./cook-video.sh -d ./director -fr 60 -o video-output vid.mp4

> **_Hot tip:_**  to see how many frames are in a video, use the `-fc` flag:
>
>     ./cook-video.sh -fc vid.mp4
>     total frames: 150