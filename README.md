**READ ME: script overview and instructions:**

This repository contains the scripts and files to replicate all
processing and analysis steps of the publication “Gaze Graphs in spatial
navigation: visual behavior during free exploration explains individual
differences in navigation performance”. Note, that the scripts of this
repository are designed to process the data uploaded in the following
OSF repositories:

-   <https://osf.io/qcn67> / <https://doi.org/10.17605/OSF.IO/QCN67>
    – the OSF repository with the uploaded eye and motion tracking
    analyzed in the referenced publication (26 participants,
    2.5 hours of free exploration of the virtual city Westbrook
    in immersive VR) 

-   <https://osf.io/32sqe> – the OSF repository with the uploaded
    pointing-to-building task performance data and FRS questionnaire
    answers analyzed in the referenced publication. Note, this
    repository also includes the compiled Windows executable of the full
    VR experiment (Unity standalone builds for the tutorials, free
    exploration phase, task and testing phase).

Specifically, this repository contains MATLAB, R, and Python scripts to:

-   Preprocess eye and motion tracking data recorded during the free
    exploration of the virtual city Westbrook in immersive VR

-   Derive gaze events and gaze graphs

-   Compute graph-theoretical analysis pipeline and visualizations

-   Analyze Point-to-Building (PTB) task performance and questionnaire
    (FRS) data, and relate performance to gaze graph properties

In addition to the scripts, the repository contains the folder
“additional_Files” in which all other required files (city building name
list, Westbrook map) are uploaded that are utilized by the repository
scripts during the analysis and to create the publication figures.

**The following table lists all scripts in the repository, their
location in the repository, and the corresponding result sections and
figures in the publication. For a full replication of the publication
results, run the scripts in the order presented in the table to ensure
that all internal dependencies are properly satisfied.**

When only running selected scripts, check the documentation in each
script for the required input files. Note that in addition to the gaze
data and gaze graphs (which are the main output from the full
pre-processing pipeline), some additional overviews are created at
different stages of the analysis/visualization scripts and are reused by
multiple scripts in subsequent analysis and visualization steps. When
running scripts outside the proposed order presented in the table, check
the required input and output information in each script to establish a
valid processing order.

For more information and instructions about the repository scripts,
notable outputs and workflow, see the notes below the table overview

<table style="width:100%;">
<colgroup>
<col style="width: 31%" />
<col style="width: 17%" />
<col style="width: 26%" />
<col style="width: 8%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Script Name</strong></th>
<th><strong>Repository structure</strong></th>
<th><strong>Paper Results Section</strong></th>
<th><strong>Figures</strong></th>
<th><strong>Notes</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><em><strong>Pre-processing</strong></em></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="5"><em><strong>Note:</strong>
Raw_Data_Preprocessing_WB.ipynb is</em> only required, when working with
the raw Json files, which are the direct output from the VR project
recordings. Due to the complex (and unreadable) Json structure, the
publication dataset is uploaded in form of the unflattened csv data
(output from <em>Raw_Data_Preprocessing_WB)</em> in the OSF repository
<a href="https://osf.io/qcn67">https://osf.io/qcn67</a>. Note, that the
CSV data files contain the identical data to the raw json files, just in
an un-nested readable CSV format.</td>
</tr>
<tr class="odd">
<td>Raw_Data_Preprocessing_WB.ipynb</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td>Only required if working with the nested json files</td>
</tr>
<tr class="even">
<td>step1_condenseRawData_WB.m</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td>First pre-processing step applied to the raw CSV data uploaded at <a
href="https://osf.io/qcn67">https://osf.io/qcn67</a></td>
</tr>
<tr class="odd">
<td>step2_checkMissingData_WB.m</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>step2_optional_joinSessions_WB</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>step3_interpolateLostData_WB.m</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>step4_gazes_vs_noise_WB.m</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td>Output: gaze data</td>
</tr>
<tr class="odd">
<td>step5_create_Graphs_WB.m</td>
<td>pre-processing-pipeline</td>
<td>Gaze graph creation</td>
<td></td>
<td>Output: gaze graphs</td>
</tr>
<tr class="even">
<td><em><strong>Analysis and visualizations</strong></em></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>visualization_first5min_walkingPaths_Gazes_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze graph creation</td>
<td>Figure 2a,b</td>
<td></td>
</tr>
<tr class="even">
<td>drawGraphMap_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze graph creation</td>
<td>Figure 2d</td>
<td></td>
</tr>
<tr class="odd">
<td>Spectral Partitioning_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze graph properties and spectral graph analysis</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>nodeDegree_createOverview_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze-graph-defined landmarks</td>
<td></td>
<td>Creates node degree overview and gaze-graph-defined landmark
list</td>
</tr>
<tr class="odd">
<td>node_degree_centrality_analysis_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze-graph-defined landmarks</td>
<td>Figure 3a,b</td>
<td></td>
</tr>
<tr class="even">
<td>Correlation_BetweenSubjects_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze-graph-defined landmarks</td>
<td>Figure 3c</td>
<td></td>
</tr>
<tr class="odd">
<td>drawGraphMap_average_node_degree_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze-graph-defined landmarks</td>
<td>Figure 3d,f &amp; Figure 4</td>
<td></td>
</tr>
<tr class="even">
<td>Hierarchy_index_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Gaze-graph-defined landmarks</td>
<td>Figure 3e</td>
<td></td>
</tr>
<tr class="odd">
<td>gazes_allParticipants_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Location and appearance of gaze-graph-defined landmarks</td>
<td></td>
<td>Creates concatenated gaze data file</td>
</tr>
<tr class="even">
<td>walkingPath_triangulation_analysis_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Location and appearance of gaze-graph-defined landmarks</td>
<td>Figure 5a,b</td>
<td></td>
</tr>
<tr class="odd">
<td>RichClub_WB.m</td>
<td>graph-theoretical-analysis</td>
<td>Interconnectedness of gaze-graph-defined landmarks</td>
<td>Figure 6a,b</td>
<td></td>
</tr>
<tr class="even">
<td>extractData_FRS_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis &amp; Modeling individual
differences in spatial task performance</td>
<td></td>
<td>Extracts relevant FRS data for subsequent scripts</td>
</tr>
<tr class="odd">
<td>dataP2B_timeStamp_dataTyp_conversion_WB.R</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td></td>
<td>Fixes mixed datatype issue in P2B csv file</td>
</tr>
<tr class="even">
<td>overview_Step1_extractData_PTB_controls_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td></td>
<td>Step 1 of performance overview creation</td>
</tr>
<tr class="odd">
<td>overview_Step2_add_trialInfo_FRS_P2BPrep_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td></td>
<td>Step 2 of performance overview creation</td>
</tr>
<tr class="even">
<td>performance_analysis_plots_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td>Figure 7b and 8a</td>
<td></td>
</tr>
<tr class="odd">
<td>performanceParticipantBoxplot_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td>Figure 8b</td>
<td></td>
</tr>
<tr class="even">
<td>task_repetition_plots_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td>Figure 8c,d</td>
<td></td>
</tr>
<tr class="odd">
<td><p>performance_analysis_anova_WB.ipynb</p>
<p>(use conda environment gaze-graphs-in-spatial-nav-env.yml to run
script)</p></td>
<td>performance-analysis-and-modeling</td>
<td>Spatial navigation performance analysis</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>repetition_Variance_magnitude_calc_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Modeling individual differences in spatial task performance</td>
<td>Figure 9a,b</td>
<td></td>
</tr>
<tr class="odd">
<td>performance_graph_properties_analysis_plots_WB.m</td>
<td>performance-analysis-and-modeling</td>
<td>Modeling individual differences in spatial task performance</td>
<td></td>
<td>Creates gaze graph measures overview</td>
</tr>
<tr class="even">
<td>mean_performance_models_WB.R</td>
<td>performance-analysis-and-modeling</td>
<td>Modeling individual differences in spatial task performance</td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

**Use the above table as the definitive index and run order. It
    lists each script, where it lives in the repo, which results
    section/figure it contributes to, and any notable outputs. The notes
    below provide the surrounding “how and why.”**

**Data prerequisites and formats**

-   Eye and motion tracking data files: flattened CSVs per participant
    per session named like
    \<ParticipantID\>Expl_S\<Session\>\*\_flattened.csv

-   Processing files and pre-processing output files: each preprocessing
    step writes participant-level CSV/MAT files. The canonical filenames
    are listed in each script documentation (e.g.,
    \<ID\>Session\<S\>ET\<E\>\_data_prepared.csv,
    \<ID\>\_condensedColliders5S_WB.mat, \<ID\>\_gazes_data_WB.mat,
    \<ID\>\_Graph_WB.mat).

-   Mapping files (in additional_Files folder):

    -   building_collider_list.csv (building names and map coordinates)

    -   list_collider_changes.csv (collider renames)

    -   map_natural_white.png and map_natural_white_flipped.png
        (Westbrook map backgrounds)

-   Raw JSON: if you have raw Unity JSON, use
    Raw_Data_Preprocessing_WB.ipynb to flatten the nested structure. For
    most users this is unnecessary; un-nested CSVs equivalent to the raw
    JSON are shared on OSF <https://osf.io/qcn67> and used by the
    presented pre-processing, analysis, and visualization pipeline.

-   The original Point-to-Building (PTB) CSV
    (df_PTB_Ctrl_Preprocessed.csv uploaded at
    <https://osf.io/32sqe/files/aruvw>) contains mixed data types in the
    TimeStampBegin column. To ensure the data are treated correctly in
    the analysis, run dataP2B_timeStamp_dataTyp_conversion_WB.R to unify
    the data types and write df_PTB_Ctrl_Preprocessed_UnixTS.csv..

**Software and environments**

-   MATLAB R2020b+ recommended

    -   Used throughout preprocessing and analysis (graph,
        adjacency/distances, plotting)

    -   Some scripts use Statistics/Curve Fitting functions (e.g.,
        Hierarchy Index, Rich Club); Image Processing is helpful for map
        visualizations

-   R \>= 4.x: dataP2B_timeStamp_dataTyp_conversion_WB.R and
    performance_graph_FRS_models_WB.R (ggplot2)

-   Python \>= 3.9: performance_anova_WB.py (pandas, statsmodels)

**General usage pattern**

-   Each MATLAB script begins with an “adjust variables” block
    (savepath, cd, PartList, mapping paths). Update these paths for your
    environment.

-   The pipeline is deterministic (no randomness). Outputs are written
    to the savepath you set.

-   Data is processed based on the given participant list. If files
    expected based on the participant list are missing, most scripts
    continue running but printout the missing data file in the console
    and save the information in a missing_participant_Files list. Modify
    the participant list to process a subset of the list or individual
    participants
    

**Run recipes (how the parts fit together)**

**A) Preprocessing (from raw data to gaze events and gaze graphs)**

pre-processing pipeline to process raw CSV files and generate gaze event
data and gaze graphs for the subsequent analysis

rawCSVs → Step 1 → Step 2 (check whether to exclude participants) →
\[Optional Step 2: join sessions\] → Step 3 → **Step 4: gaze events** →
**Step 5: gaze graphs**

-   Outputs per participant include:

    -   condensedColliders_WB.mat (Step 1)

    -   interpolatedColliders_5Sessions_WB.mat (Step 3)

    -   gazes_data_WB.mat (Step 4)

    -   Graph_WB.mat (Step 5)

**B) Graph-theoretical analysis pipeline and visualizations (use your
table for specific results sections and figure mapping)**

-   Spectral analysis

    -   Spectral_Partitioning_WB.m → eigenvector/spy/cluster plots +
        CutEdges.mat + SpectralDocumentation.mat

-   Node degree centrality, correlations, hierarchy index,
    gaze-graph-defined landmarks

    -   nodeDegree_createOverview_WB.m → Overview_NodeDegree.mat

    -   node_degree_centrality_analysis_WB.m → image-scale/boxplots +
        landmarkOverview.csv

    -   drawGraphMap_average_node_degree_WB.m → map plots +
        list_gaze_graph_defined_landmarks.mat

    -   Correlation_BetweenSubjects_WB.m → histogram +
        CorrelationArray.mat

    -   Hierarchy_Index_WB.m → per-participant slope + histogram +
        HierarchyIndex_Table.mat

-   Triangulation and visibility (grid-based overlays)

    -   gazes_allParticipants_WB.m → gazes_allParticipants.mat
        (aggregated gazes)

    -   walkingPath_triangulation_analysis_WB.m → walking-path density;
        landmark visibility maps (0/1/≥2); area/time pie charts;
        logical3D\*.mat and summary tables

-   Rich club

    -   Rich_Club_WB.m → RC curves, count maps +
        RichClub_AllSubs/Mean_RichClub and per-building counts

-   Visualization scripts

    -   drawGraphMap_WB.m → per-participant graph over map

    -   visualizations_first5min_walkingPaths_gazes_WB.m → first 5
        minutes walking paths + gaze hits

**D) PTB performance, FRS, and modeling**

-   Data preparation

    -   extractData_FRS_WB.m → Overview_FRS_Data.mat/.csv (per-scale
        means/SDs; prints summary stats)

    -   dataP2B_timeStamp_dataTyp_conversion_WB.R →
        df_PTB_Ctrl_Preprocessed_UnixTS.csv (normalize TimeStampBegin to
        Unix seconds)

    -   overview_Step1_extractData_PTB_controls_WB.m → selects relevant
        data from large performance overview file

    -   overview_Step2_add_trialInfo_FRS_P2BPrep_WB.m → merge FRS;
        RouteID; trial order; repetition metrics;
        overviewTable_P2B_Prep_complete\.csv

-   Spatial navigation performance analysis

    -   performance_analysis_plots_WB.m → overviewPerformance.mat/.csv;
        histogram_performance.png; imagescale/error-bar plots;
        taskBuildings_onMap.png (Figures 7b, 8a)

    -   performanceParticipantBoxplot_WB.m → participant-level boxplots
        (Figure 8b)

    -   task_repetition_plots_WB.m → repetition comparison plots (Figure
        8c,d)

    -   performance_analysis_anova_WB.ipynb (use conda env
        gaze-graphs-in-spatial-nav-env.yml) → repeated-measures ANOVA on
        RecalculatedAngle (within: TrialOrder, RouteID; subject:
        SubjectID)

-   Modeling individual differences in spatial task performance

    -   repetition_Variance_magnitude_calc_WB.m → variance decomposition
        for repetitions (Figure 9a,b)

    -   performance_graph_properties_analysis_plots_WB.m →
        overviewGraphMeasures.mat/.csv; scatter/hist plots relating mean
        performance to nrViewedHouses, nrEdges, density, diameter,
        hierarchyIndex

    -   mean_performance_models_WB.R → linear models of meanPerformance
        vs FRS (Mean_egocentric_global, Mean_survey, Mean_cardinal) and
        graph properties; model summaries/diagnostics

**Key inputs/outputs (quick reference)**

-   Main eye and motion tracking data files used for analysis and
    visualizations (output of pre-processing pipeline)

    -   gazes_data_WB.mat

    -   Graph_WB.mat

-   Other common input files:

    -   building_collider_list.csv

    -   map_natural_white(\_flipped).png

-   Aggregated data overviews to facilitate usage in subsequent
    processing scripts:

    -   gazes_allParticipants.mat

    -   overview_NodeDegree.mat

    -   list_gaze_graph_defined_landmarks.mat

-   PTB performance data overviews:

    -   Overview_FRS_Data.csv

    -   selectedData_P2B_control.csv

    -   overviewTable_P2B_Prep_complete.csv

    -   overviewPerformance.csv

    -   overviewGraphMeasures.csv

**Tips and troubleshooting**

-   Paths and OS: Most scripts use Windows-style absolute paths. Update
    savepath and cd at the top of each script to your locations. If you
    prefer relative paths, mirror the repo structure and point savepath
    into a derivatives or analysis directory.

-   Map orientation: Use map_natural_white_flipped.png for MATLAB
    overlays (axes are set to “normal” orientation in scripts).

-   Missing data: Step 2 prints summaries of missing-data rates; several
    scripts write Missing_Participant_Files lists.

-   Reproducibility: Scripts are deterministic; no random seed required.
    Toolbox versions can slightly affect fits/plots.

**License and citation**

License: GNU General Public License v3.0 (GPL-3.0). See LICENSE in this
repository.

**Please cite the associated paper and acknowledge
“gaze-graphs-in-spatial-navigation” if you reuse scripts. For questions
or issues, open a GitHub issue or contact the author Jasmin L. Walter
(<jawalter@uni-osnabrueck.de>).**
