We define two experimental setups, one using a single still image as the probe, the other using a single video as the probe.

The still image comparisons are defined by still_gallery.txt and still_probe.txt. Each line of these files lists a single LFW image, or YTF video. Videos are directory names ending with '/' and still images contain a .jpg filename.

In both cases, there is a single probe set, and a single gallery set. The probe set contains a single image/video, and the gallery set contains all other media for each gallery subject.

For both cases, we consider using a single still image as the gallery, using all available still images as the gallery, and all available still images and videos as the gallery. The first two cases (single and multiple image galleries) are evaluated using subsets of the complete gallery. For the single image case, the first listed still image per subject is used, and for the multiple still image case, all available still images per subject are used.