fluidPage(
  fluidRow(
    div(
      id="mainbody",
      div(style="text-align:center;margin-top:0px;font-size:200%;color:darkred",
          HTML("~~ <em>Dear Users, Welcome to check the help document</em> ~~")),
      div(style="width:fit-content;width:-webkit-fit-content;width:-moz-fit-content;font-size:130%;margin-top:5px",
          HTML("
                  <h1 id='mrm-ion-pair-finder'>MRM-Ion Pair Finder</h1>
<h2 id='introduction'>Introduction</h2>
<p>Pseudotargeted metabolomics is a novel method that perform high coverage metabolomics analysis based on UHPLC-TQMS. MRM-Ion Pair Finder software is an independently developed and written program in our laboratory for large-scale selection of MRM transitions for pseudotargeted metabolomics. The Matlab (Version 7.14.739, R2012a,64-bit) is used. MRM-Ion Pair Finder v2.0 is improved on the basis of the original version, which simplifies the program and improves the running efficiency. Matlab language (R2018b, 64-bit) is used. To make MRM-Ion Pair Finder can be used by more researchers, we also provide a version based on R.</p>
<h2 id='development'>Development</h2>
<p>MRM-Ion Pair Finder is used to automatically and systematically define MRM transitions from untargeted metabolomics data. Our research group first introduced the concept of pseudotargeted metabolomics using the retention time locking GC-MS-selected ions monitoring in 2012. The pseudotargeted metabolomics method was extended to LC-MS in 2013. To define ion pairs automatically and systematically, the in-house software “Mul-tiple Reaction Monitoring-Ion Pair Finder (MRM-Ion Pair Finder)” was developed, which made defining of the MRM transitions for untargeted metabolic profiling easier and less time consuming. Recently, MRM-Ion Pair Finder was updated to version 2.0. The new version is more convenient, consumes less time and is also suitable for negative ion mode. And the function of MRM-Ion Pair Finder is also performed in R so that users have more options when using pseudotargeted method.</p>
<h2 id='how-to-use'>How to use</h2>
<h3 id='r'>R</h3>
<p>There is a function named &quot;MRM_Ion_Pair_Finder&quot; in the &quot;R&quot; folder. The function is used to pick ion pairs from MS1 peak detection result and mgf files. And we provided an example which can be seen in the same folder.</p>
<h4 id='parameters-of-mrm_ion_pair_finder'>Parameters of MRM_Ion_Pair_Finder</h4>
<table>
	<thead>
		<tr>
			<th align='left'>Parameters</th>
			<th align='left'>Meaning</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align='left'>file_MS1</td>
			<td align='left'>MS1 file (.csv)</td>
		</tr>
		<tr>
			<td align='left'>filepath_MS2</td>
			<td align='left'>filepath of MS2 file (.mgf)</td>
		</tr>
		<tr>
			<td align='left'>tol_mz</td>
			<td align='left'>m/z tolerance between MS1 and MS2 files</td>
		</tr>
		<tr>
			<td align='left'>tol_rt</td>
			<td align='left'>retention time tolerance between MS1 and MS2 files</td>
		</tr>
		<tr>
			<td align='left'>diff_MS2MS1</td>
			<td align='left'>smallest tolerance between precusor and product ion</td>
		</tr>
		<tr>
			<td align='left'>ms2_intensity</td>
			<td align='left'>smallest intensity of product ion</td>
		</tr>
		<tr>
			<td align='left'>resultpath</td>
			<td align='left'>result(.csv) filepath</td>
		</tr>
		<tr>
			<td align='left'>OnlyKeepChargeEqual1</td>
			<td align='left'>If TRUE, only keep the MS2 spectra with charge = 1.</td>
		</tr>
	</tbody>
</table>
<h4 id='notice！！！'>Notice！！！</h4>
<p>The csv file of file_MS1 should follow the format as described in the pseudotargeted metabolomics paper (
	<a href='https://pubmed.ncbi.nlm.nih.gov/32581297/'>https://pubmed.ncbi.nlm.nih.gov/32581297/</a>). It should contains &quot;mz&quot;, &quot;tr&quot;, and the columns for intensity.
</p>
<h3 id='matlab'>Matlab</h3>
<p>There is a user mannal in &quot;Matlab&quot; folder. The user mannal contains the detials of how to use the software.</p>
<h3 id='codes-for-peak-detection-and-annotation'>Codes for peak detection and annotation</h3>
<p>We provide the codes for peak detection, peak annotation and removing rundant features in the folder named &quot;Peak detection and annotation&quot;. Users should used suitable parameters for peak detection and annoation and notice the ion mode.</p>
<h3 id='codes-for-retention-time-calibration'>Codes for retention time calibration</h3>
<p>We provide the codes for retention time calibration in the folder named &quot;Retention time calibration&quot;. And we give the example data which are saved in .txt files. Users can easily calibrate retention time by using these codes.</p>
<h2 id='contact-us'>Contact us</h2>
<p>If you have any problems when you use MRM_Ion_Pair_Finder. Please contact us, you can send an emial to 
	<a href='mailto:&#122;&#104;&#101;&#x6e;&#x67;&#x66;&#106;&#x40;&#100;&#105;&#99;&#x70;&#x2e;&#97;&#x63;&#x2e;&#x63;&#x6e;'>&#122;&#104;&#101;&#x6e;&#x67;&#x66;&#106;&#x40;&#100;&#105;&#99;&#x70;&#x2e;&#97;&#x63;&#x2e;&#x63;&#x6e;</a>
  </p>
  <h2 id='revision-history'>revision history</h2>
  <h3 id='20200916'>2020/09/16</h3>
  <p>Modified column name support in MS1 file. The modified version supports the use of &quot;tr&quot; or &quot;rt&quot; abbreviations for retention time column names.</p>
  <h3 id='20200928'>2020/09/28</h3>
  <p>Expanded format support for mgf files</p>
  
               ")),
      column(img(src = "The_workflow_of_MetEx.png", align = "center", width = "85%"), align = "center", width = 12),

      column(3)

  )
)
)
