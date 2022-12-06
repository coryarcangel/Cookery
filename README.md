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
- `-f` image_file (default: selbu.jpg) 

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

    ./deepfry.sh -n 10 -o output_folder -s 1 -f selbu.jpg
  

By default, deep fry steps will be saved to history.txt. T save elsewhere, use `-h` [filename].
All history is also appended to scratch.txt as a backup in case a good sequence gets lost. 
To replay a history file, supply it with the `-r` flag.

To replay a history file: 

    ./deepfry.sh -r history.txt -o output_folder -f selbu.jpg

**DEEP FRY A VIDEO**

The `deepfry-video.sh` script requires a .mp4 file and a history file generated while deep frying an image.
You can also optionally provide a framerate. The default is 30 fps. Here's how to deep fry a video at 60 frames per second, saving all intermediate files in the `video-output` folder:

    ./deepfry-video.sh -r history.txt -r 60 -o video-output vid.mp4

This script generates individual frames from the video at the specified framerate, saves deep fried versions of each frame following the history file into a `deepfried` subfolder, and recombines those frames back into a video called `out.mp4` in `deepfried`. It also copies over the sound
