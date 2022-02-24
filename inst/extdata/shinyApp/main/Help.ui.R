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
<h4 id='r'>R</h4>
<p>We package the functions of MRM-Ion Pair Finder into an R language package called MRMFinder, which is convenient for users to download, install and use.</p>
<p>To install MRMFinder, you need to install devtools first, use the following code in R language.</p>
<pre>
	<code class='language-R'>install.packages(&quot;devtools&quot;)
</code>
</pre>
<p>After installing devtools, install MRMFinder using the code below:</p>
<pre>
	<code class='language-R'>devtools::install_github(&quot;zhengfj1994/MRM-Ion_Pair_Finder&quot;)
</code>
</pre>
<p>After successful installation, you can use the MRM_Ion_Pair_Finder function to select transitions.</p>
<pre>
	<code class='language-R'>library(MRMFinder)
data_ms1ms2_final &lt;- MRM_Ion_Pair_Finder(file_MS1 = &quot;F:\\MRM-Ion Pair Finder\\MS1\\Delete Iso-Add Result.csv&quot;,
                                         filepath_MS2 = &quot;F:\\MRM-Ion Pair Finder\\MS2&quot;,
                                         tol_mz = 0.01,
                                         tol_tr = 0.2,
                                         diff_MS2MS1 = 13.9,
                                         ms2_intensity = 750,
                                         resultpath = &quot;F:\\MRM-Ion Pair Finder&quot;,
                                         OnlyKeepChargeEqual1 = T)
</code>
</pre>
<p>The meaning of parameters are shown below:</p>
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
<h5 id='notice！！！'>Notice！！！</h5>
<p>The csv file of file_MS1 should follow the format as described in the pseudotargeted metabolomics paper (
	<a href='https://pubmed.ncbi.nlm.nih.gov/32581297/'>https://pubmed.ncbi.nlm.nih.gov/32581297/</a>). It should contains &quot;mz&quot;, &quot;tr&quot;, and the columns for intensity.
</p>
<h4 id='shiny'>Shiny</h4>
<p>In order to facilitate the use of users who are not used to using the R language, we also visualized based on shiny. After the MRMFinder is installed successfully, the user can use the following command to invoke the shiny visual interface.</p>
<pre>
	<code class='language-R'>shiny::runApp(system.file(&#39;extdata/shinyApp&#39;, package = &#39;MRMFinder&#39;))
</code>
</pre>
<h4 id='independent-of-r-language'>Independent of R language</h4>
<p>For users who don&#39;t want to use R language, we provide a packaged independent program, users do not need to install R language.</p>
<h3 id='codes-for-peak-detection-and-annotation'>Codes for peak detection and annotation</h3>
<p>We provide the codes for peak detection, peak annotation and removing rundant features in the folder named &quot;PeakDetectionAndAnnotation&quot;. Users should used suitable parameters for peak detection and annoation and notice the ion mode.</p>
<h3 id='codes-for-retention-time-calibration'>Codes for retention time calibration</h3>
<p>We provide the codes for retention time calibration in the folder named &quot;RetentionTimeCalibration&quot;. And we give the example data which are saved in .txt files. Users can easily calibrate retention time by using these codes.</p>
<h2 id='contact-us'>Contact us</h2>
<p>If you have any problems when you use MRM_Ion_Pair_Finder. Please contact us, you can send an emial to
	<a href='mailto:&#122;&#104;&#101;&#x6e;&#103;&#102;&#106;&#x40;&#100;&#105;&#x63;&#112;&#x2e;&#x61;&#x63;&#x2e;&#x63;&#x6e;'>&#122;&#104;&#101;&#x6e;&#103;&#102;&#106;&#x40;&#100;&#105;&#x63;&#112;&#x2e;&#x61;&#x63;&#x2e;&#x63;&#x6e;</a>
  </p>
  <h2 id='revision-history'>revision history</h2>
  <h3 id='20200916'>2020/09/16</h3>
  <p>Modified column name support in MS1 file. The modified version supports the use of &quot;tr&quot; or &quot;rt&quot; abbreviations for retention time column names.</p>
  <h3 id='20200928'>2020/09/28</h3>
  <p>Expanded format support for mgf files.</p>
  <h3 id='20210216'>2021/02/16</h3>
  <p>Improve the efficiency of the R language and visualize it based on shiny. Remove the Matlab version.</p>
  <h3 id='20210224'>2021/02/24</h3>
  <p>Add error notification.</p>


               ")),
      column(3)

  )
)
)
