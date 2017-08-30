# Research Stuff
This is the prototype code for a time series tool application for MATLAB.
The tool will aid in visualizing repeated time series subsequences through the use of a time series dictionary. The dictionary is learned from the input data.

## Todo
- Refine F_beta scoring function (more specifically, how to calculate recall and effects of subsequence length)
- Option to search over multiple MPs for a set of lengths
- Improve candidate search for small data
- Create function to adjust threshold, also for future user editing of threshold
- Visualization of neighbor distribution for a template or candidate
- Test dictionary mat file conversion to plain text file
- Test algorithm on noisy synthetic data of various classes and similar classes with noisy regions
- Implement dictionary usage for unlabeled data 

## Bugs:
- Importing data sometimes fails to correctly modify the region labels graph