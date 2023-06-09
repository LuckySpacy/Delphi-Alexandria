        ��  ��                  ��  4   ��
 M A K E R N O T E S         0         ; --------------------------------------------------------------------------------------
; General Notes
; --------------------------------------------------------------------------------------
; In the first instance, a MakerNote format needs to have a TExifMakerNote descendent
; for it, which is then registered with TExifData. CCR.Exif.pas itself implements and
; registers ones for Canon, Panasonic and Sony MakerNotes. As long as any given format
; uses an Exif-standard TIFF structure and there is information for it available of the
; sort provided in the table at http://www.exiv2.org/makernote.html, however, it should
; not be too hard to write a custom descendent - check out the source to the built-in
; ones.
;
; Once the appropriate TExifMakerNote descendent is available, you can then map tag IDs
; and values to their string descriptions using this file. At its simplest, the format
; is the following:
;
; [ClassName.$HexTagID]
; TagDescription=This is the tag description
; TagValue=Value description
;
; Here, ClassName is the class name of the relevant TExifMakerNote descendent, and
; TagValue is whatever TExifTag.AsString produces. In the case of some MakerNote formats,
; though, a single tag can contain may different settings. If done in a manner whereby
; the parent tag is an array one (so, the ElementCount property of TExifTag returns a
; figure greater than 1), it can be handled here as thus:
;
; [ClassName.$HexTagID]
; TagDescription=This is the tag description (used when an unrecognised element is found)
; TreatAsTagGroup=1
;
; [ClassName.$HexTagID(ElementIndex)]
; TagDescription=This is the tag element description

; --------------------------------------------------------------------------------------
; Canon - data mostly from http://owl.phy.queensu.ca/~phil/exiftool/TagNames/Canon.html
; --------------------------------------------------------------------------------------

[TCanonMakerNote.$0001]
TagDescription=Camera settings
TreatAsTagGroup=1

[TCanonMakerNote.$0001(1)]
TagDescription=Macro mode
1=On
2=Off

[TCanonMakerNote.$0001(2)]
TagDescription=Self timer

[TCanonMakerNote.$0001(3)]
TagDescription=Quality
1=Economy
2=Normal
3=Fine
4=RAW
5=Super fine
130=Normal movie

[TCanonMakerNote.$0001(4)]
TagDescription=Flash mode
0=Off
1=Auto
2=On
3=Red-eye reduction
4=Slow-sync
5=Auto red-eye reduction
6=Red-eye reduction on
16=External flash

[TCanonMakerNote.$0001(5)]
TagDescription=Drive mode
0=Single
1=Continuous
2=Movie
3=Continuous, speed priority
4=Continuous, low
5=Continuous, hgh

[TCanonMakerNote.$0001(7)]
TagDescription=Focus mode
0=One-shot auto-focus
1=AI Servo auto-focus
2=AI Focus auto-focus
3=Manual focus
4=Single
5=Continuous
6=Manual focus
16=Pan Focus

[TCanonMakerNote.$0001(9)]
TagDescription=Recording mode
1=JPEG
2=CRW (THM)
3=AVI (THM)
4=TIFF
5=TIFF (JPEG)

[TCanonMakerNote.$0001(10)]
TagDescription=Image size
0=Large
1=Medium
2=Small
5=Medium 1
6=Medium 2
7=Medium 3
8=Postcard
9=Widescreen
129=Medium movie
130=Small movie

[TCanonMakerNote.$0001(11)]
TagDescription=Easy mode
0=Full auto
1=Manual
2=Landscape
3=Fast shutter
4=Slow shutter
5=Night
6=Grayscale
7=Sepia
8=Portrait
9=Sports
10=Macro
11=Black and white
12=Pan focus
13=Vivid
14=Neutral
15=Flash Off
16=Long shutter
17=Super macro
18=Foliage
19=Indoor
20=Fireworks
21=Beach
22=Underwater
23=Snow
24=Kids and pets
25=Night snapshot
26=Digital macro
27=My colours
28=Still image
30=Color accent
31=Color swap
32=Aquarium
33=ISO 3200
38=Creative auto
261=Sunset

[TCanonMakerNote.$0001(12)]
TagDescription=Digital zoom
0=None
1=2x
2=4x
3=Other

[TCanonMakerNote.$0001(13)]
TagDescription=Contrast
0=Normal

[TCanonMakerNote.$0001(14)]
TagDescription=Saturation
0=Normal

[TCanonMakerNote.$0001(15)]
TagDescription=Sharpness

[TCanonMakerNote.$0001(16)]
TagDescription=ISO speed

[TCanonMakerNote.$0001(17)]
TagDescription=Metering mode
0=Default
1=Spot
2=Average
3=Evaluative
4=Partial
5=Centre-weighted average

[TCanonMakerNote.$0001(18)]
TagDescription=Focus type
0=Manual
1=Auto
2=Not known
3=Macro
4=Very close
5=Close
6=Middle range
7=Far range
8=Pan focus
9=Super macro
10=Infinity

[TCanonMakerNote.$0001(19)]
TagDescription=Auto-focus point
8197=Manual
12288=None (MF)
12289=Auto
12290=Right
12291=Centre
12292=Left
16385=Auto
16390=Face detect

[TCanonMakerNote.$0001(20)]
TagDescription=Exposure mode
0=Easy
1=Program auto-exposure
2=Shutter speed priority auto-exposure
3=Aperture-priority auto-exposure
4=Manual
5=Depth-of-field auto-exposure
6=M-Dep
7=Bulb

[TCanonMakerNote.$0001(22)]
TagDescription=Lens type
1	= Canon EF 50mm f/1.8
2	= Canon EF 28mm f/2.8
3	= Canon EF 135mm f/2.8 Soft
4	= Canon EF 35-105mm f/3.5-4.5 or Sigma Lens
4.1	= Sigma UC Zoom 35-135mm f/4-5.6
5	= Canon EF 35-70mm f/3.5-4.5
6	= Canon EF 28-70mm f/3.5-4.5 or Sigma or Tokina Lens
6.1	= Sigma 18-50mm f/3.5-5.6 DC
6.2	= Sigma 18-125mm f/3.5-5.6 DC IF ASP
6.3	= Tokina AF193-2 19-35mm f/3.5-4.5
6.4	= Sigma 28-80mm f/3.5-5.6 II Macro
7	= Canon EF 100-300mm f/5.6L
8	= Canon EF 100-300mm f/5.6 or Sigma or Tokina Lens
8.1	= Sigma 70-300mm f/4-5.6 [APO] DG Macro
8.2	= Tokina AT-X242AF 24-200mm f/3.5-5.6
9	= Canon EF 70-210mm f/4
9.1	= Sigma 55-200mm f/4-5.6 DC
10	= Canon EF 50mm f/2.5 Macro or Sigma Lens
10.1	= Sigma 50mm f/2.8 EX
10.2	= Sigma 28mm f/1.8
10.3	= Sigma 105mm f/2.8 Macro EX
10.4	= Sigma 70mm f/2.8 EX DG Macro EF
11	= Canon EF 35mm f/2
13	= Canon EF 15mm f/2.8 Fisheye
14	= Canon EF 50-200mm f/3.5-4.5L
15	= Canon EF 50-200mm f/3.5-4.5
16	= Canon EF 35-135mm f/3.5-4.5
17	= Canon EF 35-70mm f/3.5-4.5A
18	= Canon EF 28-70mm f/3.5-4.5
20	= Canon EF 100-200mm f/4.5A
21	= Canon EF 80-200mm f/2.8L
22	= Canon EF 20-35mm f/2.8L or Tokina Lens
22.1	= Tokina AT-X280AF PRO 28-80mm f/2.8 Aspherical
23	= Canon EF 35-105mm f/3.5-4.5
24	= Canon EF 35-80mm f/4-5.6 Power Zoom
25	= Canon EF 35-80mm f/4-5.6 Power Zoom
26	= Canon EF 100mm f/2.8 Macro or Other Lens
26.1	= Cosina 100mm f/3.5 Macro AF
26.2	= Tamron SP AF 90mm f/2.8 Di Macro
26.3	= Tamron SP AF 180mm f/3.5 Di Macro
26.4	= Carl Zeiss Planar T* 50mm f/1.4
27	= Canon EF 35-80mm f/4-5.6
28	= Canon EF 80-200mm f/4.5-5.6 or Tamron Lens
28.1	= Tamron SP AF 28-105mm f/2.8 LD Aspherical IF
28.2	= Tamron SP AF 28-75mm f/2.8 XR Di LD Aspherical [IF] Macro
28.3	= Tamron AF 70-300mm f/4.5-5.6 Di LD 1:2 Macro Zoom
28.4	= Tamron AF Aspherical 28-200mm f/3.8-5.6
29	= Canon EF 50mm f/1.8 II
30	= Canon EF 35-105mm f/4.5-5.6
31	= Canon EF 75-300mm f/4-5.6 or Tamron Lens
31.1	= Tamron SP AF 300mm f/2.8 LD IF
32	= Canon EF 24mm f/2.8 or Sigma Lens
32.1	= Sigma 15mm f/2.8 EX Fisheye
33	= Voigtlander or Zeiss Lens
33.1	= Voigtlander Ultron 40mm f/2 SLII Aspherical
33.2	= Zeiss Distagon 35mm T* f/2 ZE
35	= Canon EF 35-80mm f/4-5.6
36	= Canon EF 38-76mm f/4.5-5.6
37	= Canon EF 35-80mm f/4-5.6 or Tamron Lens
37.1	= Tamron 70-200mm f/2.8 Di LD IF Macro
37.2	= Tamron AF 28-300mm f/3.5-6.3 XR Di VC LD Aspherical [IF] Macro Model A20
37.3	= Tamron SP AF 17-50mm f/2.8 XR Di II VC LD Aspherical [IF]
37.4	= Tamron AF 18-270mm f/3.5-6.3 Di II VC LD Aspherical [IF] Macro
38	= Canon EF 80-200mm f/4.5-5.6
39	= Canon EF 75-300mm f/4-5.6
40	= Canon EF 28-80mm f/3.5-5.6
41	= Canon EF 28-90mm f/4-5.6
42	= Canon EF 28-200mm f/3.5-5.6 or Tamron Lens
42.1	= Tamron AF 28-300mm f/3.5-6.3 XR Di VC LD Aspherical [IF] Macro Model A20
43	= Canon EF 28-105mm f/4-5.6
44	= Canon EF 90-300mm f/4.5-5.6
45	= Canon EF-S 18-55mm f/3.5-5.6 [II]
46	= Canon EF 28-90mm f/4-5.6
48	= Canon EF-S 18-55mm f/3.5-5.6 IS
49	= Canon EF-S 55-250mm f/4-5.6 IS
50	= Canon EF-S 18-200mm f/3.5-5.6 IS
51	= Canon EF-S 18-135mm f/3.5-5.6 IS
52	= Canon EF-S 18-55mm f/3.5-5.6 IS II
94	= Canon TS-E 17mm f/4L
95	= Canon TS-E 24.0mm f/3.5 L II
124	= Canon MP-E 65mm f/2.8 1-5x Macro Photo
125	= Canon TS-E 24mm f/3.5L
126	= Canon TS-E 45mm f/2.8
127	= Canon TS-E 90mm f/2.8
129	= Canon EF 300mm f/2.8L
130	= Canon EF 50mm f/1.0L
131	= Canon EF 28-80mm f/2.8-4L or Sigma Lens
131.1	= Sigma 8mm f/3.5 EX DG Circular Fisheye
131.2	= Sigma 17-35mm f/2.8-4 EX DG Aspherical HSM
131.3	= Sigma 17-70mm f/2.8-4.5 DC Macro
131.4	= Sigma APO 50-150mm f/2.8 [II] EX DC HSM
131.5	= Sigma APO 120-300mm f/2.8 EX DG HSM
132	= Canon EF 1200mm f/5.6L
134	= Canon EF 600mm f/4L IS
135	= Canon EF 200mm f/1.8L
136	= Canon EF 300mm f/2.8L
137	= Canon EF 85mm f/1.2L or Sigma or Tamron Lens
137.1	= Sigma 18-50mm f/2.8-4.5 DC OS HSM
137.2	= Sigma 50-200mm f/4-5.6 DC OS HSM
137.3	= Sigma 18-250mm f/3.5-6.3 DC OS HSM
137.4	= Sigma 24-70mm f/2.8 IF EX DG HSM
137.5	= Sigma 18-125mm f/3.8-5.6 DC OS HSM
137.6	= Sigma 17-70mm f/2.8-4 DC Macro OS HSM
137.7	= Tamron AF 18-270mm f/3.5-6.3 Di II VC PZD
138	= Canon EF 28-80mm f/2.8-4L
139	= Canon EF 400mm f/2.8L
140	= Canon EF 500mm f/4.5L
141	= Canon EF 500mm f/4.5L
142	= Canon EF 300mm f/2.8L IS
143	= Canon EF 500mm f/4L IS
144	= Canon EF 35-135mm f/4-5.6 USM
145	= Canon EF 100-300mm f/4.5-5.6 USM
146	= Canon EF 70-210mm f/3.5-4.5 USM
147	= Canon EF 35-135mm f/4-5.6 USM
148	= Canon EF 28-80mm f/3.5-5.6 USM
149	= Canon EF 100mm f/2 USM
150	= Canon EF 14mm f/2.8L or Sigma Lens
150.1	= Sigma 20mm EX f/1.8
150.2	= Sigma 30mm f/1.4 DC HSM
150.3	= Sigma 24mm f/1.8 DG Macro EX
151	= Canon EF 200mm f/2.8L
152	= Canon EF 300mm f/4L IS or Sigma Lens
152.1	= Sigma 12-24mm f/4.5-5.6 EX DG ASPHERICAL HSM
152.2	= Sigma 14mm f/2.8 EX Aspherical HSM
152.3	= Sigma 10-20mm f/4-5.6
152.4	= Sigma 100-300mm f/4
153	= Canon EF 35-350mm f/3.5-5.6L or Sigma or Tamron Lens
153.1	= Sigma 50-500mm f/4-6.3 APO HSM EX
153.2	= Tamron AF 28-300mm f/3.5-6.3 XR LD Aspherical [IF] Macro
153.3	= Tamron AF 18-200mm f/3.5-6.3 XR Di II LD Aspherical [IF] Macro Model A14
153.4	= Tamron 18-250mm f/3.5-6.3 Di II LD Aspherical [IF] Macro
154	= Canon EF 20mm f/2.8 USM
155	= Canon EF 85mm f/1.8 USM
156	= Canon EF 28-105mm f/3.5-4.5 USM or Tamron Lens
156.1	= Tamron SP 70-300mm f/4.0-5.6 Di VC USD
160	= Canon EF 20-35mm f/3.5-4.5 USM or Tamron or Tokina Lens
160.1	= Tamron AF 19-35mm f/3.5-4.5
160.2	= Tokina AT-X 124 AF 12-24mm f/4 DX
161	= Canon EF 28-70mm f/2.8L or Sigma or Tamron Lens
161.1	= Sigma 24-70mm f/2.8 EX
161.2	= Sigma 28-70mm f/2.8 EX
161.3	= Tamron AF 17-50mm f/2.8 Di-II LD Aspherical
161.4	= Tamron 90mm f/2.8
162	= Canon EF 200mm f/2.8L
163	= Canon EF 300mm f/4L
164	= Canon EF 400mm f/5.6L
165	= Canon EF 70-200mm f/2.8 L
166	= Canon EF 70-200mm f/2.8 L + 1.4x
167	= Canon EF 70-200mm f/2.8 L + 2x
168	= Canon EF 28mm f/1.8 USM
169	= Canon EF 17-35mm f/2.8L or Sigma Lens
169.1	= Sigma 18-200mm f/3.5-6.3 DC OS
169.2	= Sigma 15-30mm f/3.5-4.5 EX DG Aspherical
169.3	= Sigma 18-50mm f/2.8 Macro
169.4	= Sigma 50mm f/1.4 EX DG HSM
169.5	= Sigma 85mm f/1.4 EX DG HSM
169.6	= Sigma 30mm f/1.4 EX DC HSM
170	= Canon EF 200mm f/2.8L II
171	= Canon EF 300mm f/4L
172	= Canon EF 400mm f/5.6L
173	= Canon EF 180mm Macro f/3.5L or Sigma Lens
173.1	= Sigma 180mm EX HSM Macro f/3.5
173.2	= Sigma APO Macro 150mm f/2.8 EX DG HSM
174	= Canon EF 135mm f/2L or Sigma Lens
174.1	= Sigma 70-200mm f/2.8 EX DG APO OS HSM
175	= Canon EF 400mm f/2.8L
176	= Canon EF 24-85mm f/3.5-4.5 USM
177	= Canon EF 300mm f/4L IS
178	= Canon EF 28-135mm f/3.5-5.6 IS
179	= Canon EF 24mm f/1.4L
180	= Canon EF 35mm f/1.4L
181	= Canon EF 100-400mm f/4.5-5.6L IS + 1.4x
182	= Canon EF 100-400mm f/4.5-5.6L IS + 2x
183	= Canon EF 100-400mm f/4.5-5.6L IS
184	= Canon EF 400mm f/2.8L + 2x
185	= Canon EF 600mm f/4L IS
186	= Canon EF 70-200mm f/4L
187	= Canon EF 70-200mm f/4L + 1.4x
188	= Canon EF 70-200mm f/4L + 2x
189	= Canon EF 70-200mm f/4L + 2.8x
190	= Canon EF 100mm f/2.8 Macro
191	= Canon EF 400mm f/4 DO IS
193	= Canon EF 35-80mm f/4-5.6 USM
194	= Canon EF 80-200mm f/4.5-5.6 USM
195	= Canon EF 35-105mm f/4.5-5.6 USM
196	= Canon EF 75-300mm f/4-5.6 USM
197	= Canon EF 75-300mm f/4-5.6 IS USM
198	= Canon EF 50mm f/1.4 USM
199	= Canon EF 28-80mm f/3.5-5.6 USM
200	= Canon EF 75-300mm f/4-5.6 USM
201	= Canon EF 28-80mm f/3.5-5.6 USM
202	= Canon EF 28-80mm f/3.5-5.6 USM IV
208	= Canon EF 22-55mm f/4-5.6 USM
209	= Canon EF 55-200mm f/4.5-5.6
210	= Canon EF 28-90mm f/4-5.6 USM
211	= Canon EF 28-200mm f/3.5-5.6 USM
212	= Canon EF 28-105mm f/4-5.6 USM
213	= Canon EF 90-300mm f/4.5-5.6 USM
214	= Canon EF-S 18-55mm f/3.5-5.6 USM
215	= Canon EF 55-200mm f/4.5-5.6 II USM
224	= Canon EF 70-200mm f/2.8L IS
225	= Canon EF 70-200mm f/2.8L IS + 1.4x
226	= Canon EF 70-200mm f/2.8L IS + 2x
227	= Canon EF 70-200mm f/2.8L IS + 2.8x
228	= Canon EF 28-105mm f/3.5-4.5 USM
229	= Canon EF 16-35mm f/2.8L
230	= Canon EF 24-70mm f/2.8L
231	= Canon EF 17-40mm f/4L
232	= Canon EF 70-300mm f/4.5-5.6 DO IS USM
233	= Canon EF 28-300mm f/3.5-5.6L IS
234	= Canon EF-S 17-85mm f4-5.6 IS USM
235	= Canon EF-S 10-22mm f/3.5-4.5 USM
236	= Canon EF-S 60mm f/2.8 Macro USM
237	= Canon EF 24-105mm f/4L IS
238	= Canon EF 70-300mm f/4-5.6 IS USM
239	= Canon EF 85mm f/1.2L II
240	= Canon EF-S 17-55mm f/2.8 IS USM
241	= Canon EF 50mm f/1.2L
242	= Canon EF 70-200mm f/4L IS
243	= Canon EF 70-200mm f/4L IS + 1.4x
244	= Canon EF 70-200mm f/4L IS + 2x
245	= Canon EF 70-200mm f/4L IS + 2.8x
246	= Canon EF 16-35mm f/2.8L II
247	= Canon EF 14mm f/2.8L II USM
248	= Canon EF 200mm f/2L IS
249	= Canon EF 800mm f/5.6L IS
250	= Canon EF 24 f/1.4L II
251	= Canon EF 70-200mm f/2.8L IS II USM
254	= Canon EF 100mm f/2.8L Macro IS USM
488	= Canon EF-S 15-85mm f/3.5-5.6 IS USM
489	= Canon EF 70-300mm f/4-5.6L IS USM
65535=Unknown 

[TCanonMakerNote.$0001(23)]
TagDescription=Lens focal length

[TCanonMakerNote.$0001(24)]
TagDescription=Lens focal length (short)

[TCanonMakerNote.$0001(25)]
TagDescription=Lens focal units

[TCanonMakerNote.$0001(26)]
TagDescription=Maximum aperture

[TCanonMakerNote.$0001(27)]
TagDescription=Minimum aperture

[TCanonMakerNote.$0001(28)]
TagDescription=Flash activity

[TCanonMakerNote.$0001(29)]
TagDescription=Flash details (is a bitmask)

[TCanonMakerNote.$0001(32)]
TagDescription=Focus continuous
0=Single
1=Continuous
8=Manual

[TCanonMakerNote.$0001(33)]
TagDescription=Auto-exposure mode
0=Normal
1=Compensation only
2=Lock only
3=Lock and compensation
4=None

[TCanonMakerNote.$0001(34)]
TagDescription=Image stabilisation
0=Off
1=On
2=On, shot only
3=On, panning

[TCanonMakerNote.$0001(35)]
TagDescription=Display aperture

[TCanonMakerNote.$0001(36)]
TagDescription=Zoom source width

[TCanonMakerNote.$0001(37)]
TagDescription=Zoom target width

[TCanonMakerNote.$0001(39)]
TagDescription=Spot metering mode
0=Centre
1=Auto-focus point

[TCanonMakerNote.$0001(40)]
TagDescription=Photo effect
0=Off
1=Vivid
2=Neutral
3=Smooth
4=Sepia
5=B&W
6=Custom
100=My colour data

[TCanonMakerNote.$0001(41)]
TagDescription=Manual flash output
0=n/a
1280=Full
1282=Medium
1284=Low
32767=n/a

[TCanonMakerNote.$0001(42)]
TagDescription=Colour tone
0=Normal

[TCanonMakerNote.$0001(46)]
TagDescription=sRAW Quality
0=n/a
1=sRAW1 (mRAW)
2=sRAW2 (sRAW)

[TCanonMakerNote.$0002]
TagDescription=Focal length
TreatAsTagGroup=1

[TCanonMakerNote.$0002(0)]
TagDescription=Focal type
1=Fixed
2=Zoom

[TCanonMakerNote.$0002(1)]
TagDescription=Focal length

[TCanonMakerNote.$0002(2)]
TagDescription=Focal plane width

[TCanonMakerNote.$0002(3)]
TagDescription=Focal plane length

[TCanonMakerNote.$0003]
TagDescription=Flash info

[TCanonMakerNote.$0004]
TagDescription=Shot info
TreatAsTagGroup=1

[TCanonMakerNote.$0004(1)]
TagDescription=Auto ISO speed

[TCanonMakerNote.$0004(2)]
TagDescription=Base ISO speed

[TCanonMakerNote.$0004(3)]
TagDescription=Measured LV

[TCanonMakerNote.$0004(4)]
TagDescription=Target aperture

[TCanonMakerNote.$0004(5)]
TagDescription=Target shutter speed

[TCanonMakerNote.$0004(6)]
TagDescription=Exposure compensation

[TCanonMakerNote.$0004(7)]
TagDescription=White balance
0=Auto
1=Daylight
2=Cloudy
3=Tungsten
4=Fluorescent
5=Flash
6=Custom
7=Black and White
8=Shade
9=Manual temperature (Kelvin)
10=PC set 1
11=PC set 2
12=PC set 3
14=Daylight Fluorescent
15=Custom 1
16=Custom 2
17=Underwater
18=Custom 3
19=Custom 4
20=PC set 4
21=PC set 5

[TCanonMakerNote.$0004(9)]
TagDescription=Slow shutter mode
0=Off
1=Night scene
2=On
3=None available

[TCanonMakerNote.$0004(9)]
TagDescription=Sequence number

[TCanonMakerNote.$0004(10)]
TagDescription=Optical zoom code

[TCanonMakerNote.$0004(13)]
TagDescription=Flash guide number

[TCanonMakerNote.$0004(14)]
TagDescription=Auto-focus point used
12288=None (MF)
12289=Right
12290=Centre
12291=Centre and right
12292=Left
12293=Left and right
12294=Left and centre
12295=All

[TCanonMakerNote.$0004(15)]
TagDescription=Flash exposure comp.

[TCanonMakerNote.$0004(16)]
TagDescription=Auto exposure bracket mode
-1=On
0=Off
1=On (shot 1)
2=On (shot 2)
3=On (shot 3)

[TCanonMakerNote.$0004(17)]
TagDescription=Auto-exposure bracket value

[TCanonMakerNote.$0004(18)]
TagDescription=Control mode
0=n/a
1=Camera local control
3=Computer remote control

[TCanonMakerNote.$0004(19)]
TagDescription=Subject distance (upper)

[TCanonMakerNote.$0004(20)]
TagDescription=Subject distance (lower)

[TCanonMakerNote.$0004(21)]
TagDescription=Aperture (F number)

[TCanonMakerNote.$0004(22)]
TagDescription=Shutter speed

[TCanonMakerNote.$0004(24)]
TagDescription=Measured EV 2

[TCanonMakerNote.$0004(25)]
TagDescription=Bulb duration

[TCanonMakerNote.$0004(26)]
TagDescription=Camera type
248=EOS high-end
250=Compact
252=EOS mid-range
255=DV camera

[TCanonMakerNote.$0004(27)]
TagDescription=Auto rotate
-1=Unknown
0=None
1=90� clockwise
2=180�
3=90� counter-clockwise

[TCanonMakerNote.$0004(28)]
TagDescription=ND filter
0=Off
1=On

[TCanonMakerNote.$0004(29)]
TagDescription=Self timer 2

[TCanonMakerNote.$0004(33)]
TagDescription=Flash output

[TCanonMakerNote.$0005]
TagDescription=Panorama
TreatAsTagGroup=1

[TCanonMakerNote.$0005(2)]
TagDescription=Panorama frame number

[TCanonMakerNote.$0005(5)]
TagDescription=Panorama direction
0=Left to right
1=Right to left
2=Bottom to top
3=Top to bottom
4=2x2 matrix (clockwise)

[TCanonMakerNote.$0006]
TagDescription=Image type

[TCanonMakerNote.$0007]
TagDescription=Firmware version

[TCanonMakerNote.$0008]
TagDescription=File number

[TCanonMakerNote.$0009]
TagDescription=Owner name

[TCanonMakerNote.$000C]
TagDescription=Serial number

[TCanonMakerNote.$000D]
TagDescription=Camera info values (meaning depends on camera)

[TCanonMakerNote.$000E]
TagDescription=File length

[TCanonMakerNote.$000F]
TagDescription=Functions (meaning depends on camera)

[TCanonMakerNote.$0010]
TagDescription=Model ID

[TCanonMakerNote.$0012]
TagDescription=Auto-focus info
TreatAsTagGroup=1

[TCanonMakerNote.$0012(0)]
TagDescription=Auto-focus - number of points

[TCanonMakerNote.$0012(1)]
TagDescription=Auto-focus - number of valid points

[TCanonMakerNote.$0012(2)]
TagDescription=Auto-focus image width

[TCanonMakerNote.$0012(3)]
TagDescription=Auto-focus image height

[TCanonMakerNote.$0012(4)]
TagDescription=Auto-focus mapped image width

[TCanonMakerNote.$0012(5)]
TagDescription=Auto-focus mapped image height

[TCanonMakerNote.$0012(6)]
TagDescription=Auto-focus area width

[TCanonMakerNote.$0012(7)]
TagDescription=Auto-focus area height

[TCanonMakerNote.$0012(8)]
TagDescription=Auto-focus X position

[TCanonMakerNote.$0012(9)]
TagDescription=Auto-focus Y position

[TCanonMakerNote.$0012(10)]
TagDescription=Auto-focus - points in focus

[TCanonMakerNote.$0012(11)]
TagDescription=Auto-focus - primary point

[TCanonMakerNote.$0013]
TagDescription=Valid thumbnail area
0,0,0,0=Full frame

[TCanonMakerNote.$0015]
TagDescription=Serial number format
2415919104=Format 1
2684354560=Format 2

[TCanonMakerNote.$001A]
TagDescription=Super macro
0=Off
1=On (mode 1)
2=On (mode 2)

[TCanonMakerNote.$001C]
TagDescription=Date stamp mode
0=Off
1=Date
2=Date and time

[TCanonMakerNote.$001D]
TagDescription=My colours

[TCanonMakerNote.$001E]
TagDescription=Firmware revision

[TCanonMakerNote.$001F]
TagDescription=Categories
;==============================JRT added tags=================
[TCanonMakerNote.$0095]
TagDescription=Lens Model

; --------------------------------------------------------------------------------------
; Panasonic - data got from various websites and my own direct testing
; --------------------------------------------------------------------------------------

[TPanasonicMakerNote.$0001]
TagDescription=Image quality
2=High
3=Standard
6=Very High
7=Raw
9=Motion Picture

[TPanasonicMakerNote.$0002]
TagDescription=Firmware version
00000100=0.1
00000300=0.3
00010000=1.0
00010100=1.1
00010200=1.2
00010300=1.3
00010400=1.4
00010500=1.5

[TPanasonicMakerNote.$0003]
TagDescription=White balance
1=Auto
2=Sunny
3=Cloudy
4=Halogen
5=Manual (preset 1)
8=Flash
10=Black and white
11=Manual (preset 2)
12=Shade
13=Preset colour temp

[TPanasonicMakerNote.$0007]
TagDescription=Focus mode
1=Auto
2=Manual
3=Auto, focus button
4=Auto, continuous

[TPanasonicMakerNote.$000F]
TagDescription=Spot mode
16,0=1 Area Focus
32,0=23 Area Focus
64,0=Face Detect Focus
;it only records Face Detect if it sees a face.

[TPanasonicMakerNote.$001A]
TagDescription=Image stabiliser
2=On (mode 1 - OIS always on)
3=Off
4=On (mode 2 - OIS shutter only)
5=On (mode 3 - OIS up/down only)

[TPanasonicMakerNote.$001C]
TagDescription=Macro mode
1=On
2=Off
257=Tele-macro
513=Macro zoom

[TPanasonicMakerNote.$001F]
TagDescription=Shooting mode
1=Normal
2=Portrait
3=Scenery
4=Sports
5=Night portrait
6=Programme
7=Aperture priority
8=Shutter priority
9=Macro
10=Spot
11=Manual
12=Movie preview
13=Panning
14=Simple
15=Colour effects
16=Self portrait
17=Economy
18=Fireworks
19=Party
20=Snow
21=Night scenery
22=Food
23=Baby
24=Soft skin
25=Candlelight
26=Starry sky
27=High sensitivity
29=Underwater
30=Beach
31=Aerial
32=Sunset
33=Pet
34=Intelligent ISO
35=Clipboard
36=High speed continuous shooting
37=Intelligent auto
39=Multi-aspect
41=Transform
42=Flash burst
43=Pin hole
44=Film grain
45=My colour
46=Photo frame
51=HDR

[TPanasonicMakerNote.$0020]
TagDescription=Audio
1=Yes
2=No

[TPanasonicMakerNote.$0021]
TagDescription=Data dump

[TPanasonicMakerNote.$0023]
TagDescription=White balance adjustment

[TPanasonicMakerNote.$0024]
TagDescription=Flash bias
6=+2 EV
5=+1 2/3 EV
4=+1 1/3 EV
3=+1 EV
2=+2/3 EV
1=+1/3 EV
0=0 EV
65535=-1/3 EV
65534=-2/3 EV
65533=-1 EV
65532=-1 1/3 EV
65531=-1 2/3 EV
65530=-2 EV

[TPanasonicMakerNote.$0025]
TagDescription=Internal serial number

[TPanasonicMakerNote.$0026]
TagDescription=Panasonic Exif version
30313030=1.0
30313031=1.01
30313032=1.02
30323030=2.0
30323031=2.01
30323032=2.02
30323130=2.1
30323131=2.11
30323132=2.12
30323230=2.2
30323231=2.21
30323232=2.22
30323330=2.3
30323430=2.4
30323530=2.5
30323630=2.6
30323730=2.7
30323830=2.8
30323930=2.9
30333030=3.0
30333130=3.1
30333230=3.2
30333330=3.3

[TPanasonicMakerNote.$0028]
TagDescription=Colour effect
1=Off
2=Warm
3=Cool
4=Black and white
5=Sepia
6=Happy

[TPanasonicMakerNote.$0029]
TagDescription=Time since powered on (1/100s)

[TPanasonicMakerNote.$002A]
TagDescription=Burst mode
0=Off
1=On
2=Infinite
4=Unlimited

[TPanasonicMakerNote.$002B]
TagDescription=Sequence number

[TPanasonicMakerNote.$002C]
TagDescription=Contrast mode
;this tag does track with tag   [$0042] Film mode
0=-2 EV soft
1=-1 EV soft
2=Normal
3=+1 EV hard
4=+2 EV hard
;http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/Panasonic.html
;following identified as DMC-GF1 which is similar to DMC-G1
7 = Nature (Color Film)
12 = Smooth (Color Film) or Pure (My Color)
17 = Dynamic (B&W Film)
22 = Smooth (B&W Film)
27 = Dynamic (Color Film)
32 = Vibrant (Color Film) or Expressive (My Color)
33 = Elegant (My Color)
37 = Nostalgic (Color Film)
41 = Dynamic Art (My Color)
42 = Retro (My Color) 

[TPanasonicMakerNote.$002D]
TagDescription=Noise reduction
0=Standard
1=Low
2=High
3=Lowest
4=Highest

[TPanasonicMakerNote.$002E]
TagDescription=Self timer
1=Off
2=10 seconds
3=2 seconds

[TPanasonicMakerNote.$0030]
TagDescription=Rotation
1=None
3=180�
6=90� counter-clockwise
8=90� clockwise

[TPanasonicMakerNote.$0031]
TagDescription=Auto-focus assistance lamp
1=Fired
2=Enabled but not used
3=Disabled but required
4=Disabled and not required
5=Fired (internal)
;fires internal lamp instead of lamp in flash

[TPanasonicMakerNote.$0032]
TagDescription=Colour mode
0=Standard
1=Natural
2=Vivid
3=Black and white
4=Sepia

[TPanasonicMakerNote.$0033]
TagDescription=Baby or pet age ($0033)
9999:99:99 00:00:00=(not set)

[TPanasonicMakerNote.$0034]
TagDescription=Optical zoom mode
1=Standard
2=Extended

[TPanasonicMakerNote.$0035]
TagDescription=Conversion lens mode
1=Off
2=Wide
3=Telephoto
4=Macro

[TPanasonicMakerNote.$0036]
TagDescription=Travel day
65535=(not set)

[TPanasonicMakerNote.$0039]
TagDescription=Contrast
0=Normal

[TPanasonicMakerNote.$003A]
TagDescription=World time location
1=Home
2=Destination

[TPanasonicMakerNote.$003B]
TagDescription=Text stamp ($003B)
1=Off
2=On

[TPanasonicMakerNote.$003C]
TagDescription=Light sensitivity
65534=Intelligent ISO
65535=Auto ISO

[TPanasonicMakerNote.$003D]
TagDescription=Advanced scene mode
1=Normal
2=Outdoor/illuminations/flower/HDR art
3=Indoor/architecture/objects/HDR black and white
4=Creative
5=Auto
7=Expressive
8=Retro
9=Pure
10=Elegant
12=Monochrome
13=Dynamic art
14=Silhouette

[TPanasonicMakerNote.$003E]
TagDescription=Text stamp ($003E)
1=Off
2=On

[TPanasonicMakerNote.$003F]
TagDescription=Faces detected

[TPanasonicMakerNote.$0040]
TagDescription=Saturation
0=Normal
65535=-1 Low
65534=-2 Low
1=+1 High
2=+2 High

[TPanasonicMakerNote.$0041]
TagDescription=Sharpness
0=Normal
65535=-1 Soft
65534=-2 Soft
1=+1 Hard
2=+2 Hard

[TPanasonicMakerNote.$0042]
TagDescription=Film mode
1=Standard colour
2=Dynamic colour
3=Nature
4=Smooth colour
5=Standard black and white
6=Dynamic black and white
7=Smooth black and white
10=Nostalgic
11=Vibrant

[TPanasonicMakerNote.$0044]
TagDescription=Color Temperature

[TPanasonicMakerNote.$0045]
TagDescription=Bracket settings
;Auto Bracket ignored if manual exposure set
;I found no code to differentiate 1/3 or 2/3 f stop bracketing
0=No bracketing
1=3 photos (0/-/+)
2=3 photos (-/0/+)
3=5 photos (0/-/+)
4=5 photos (-/0/+)
5=7 photos (0/-/+)
6=7 photos (-/0/+)

[TPanasonicMakerNote.$0046]
TagDescription=WB adjust AB

[TPanasonicMakerNote.$0047]
TagDescription=WB adjust GM

[TPanasonicMakerNote.$0048]
TagDescription=Flash synch
0=None
1=1st curtain (normal)
2=2nd curtain (for slow shutter)

[TPanasonicMakerNote.$0049]
TagDescription=Long Shutter Noise Reduction?
1=No
2=Yes

[TPanasonicMakerNote.$004B]
; always 0 on my camera, but other G series cameras work.
TagDescription=Image Width

[TPanasonicMakerNote.$004C]
; always 0
TagDescription=Image Height

[TPanasonicMakerNote.$004D]
TagDescription=Auto-focus point position

[TPanasonicMakerNote.$004E]
TagDescription=Face detection info

[TPanasonicMakerNote.$0051]
TagDescription=Lens type

[TPanasonicMakerNote.$0052]
TagDescription=Lens serial number (internal)

[TPanasonicMakerNote.$0053]
TagDescription=Accessory type

[TPanasonicMakerNote.$0059]
TagDescription=Transformation
00000000=Off

[TPanasonicMakerNote.$005D]
TagDescription=Intelligent exposure
0=Off
1=Low
2=Standard
3=High

[TPanasonicMakerNote.$0060]
TagDescription=Lens firmware version
00010000=1.0
00010100=1.1
00010200=1.2
00010300=1.3
00010400=1.4
00010500=1.5
[TPanasonicMakerNote.$0061]
TagDescription=Facial recognition info

[TPanasonicMakerNote.$0062]
TagDescription=Flash warning
0=No
1=Yes (flash required but disabled)

[TPanasonicMakerNote.$0E00]
TagDescription=PrintIM

[TPanasonicMakerNote.$8000]
TagDescription=MakerNote version
30313030=1.0
30313031=1.01
30313032=1.02
30313131=1.11
30313230=1.2
30313231=1.21
30313330=1.30
30313331=1.31
30313332=1.32
30313333=1.33
30313334=1.34
30313335=1.35
30313336=1.36

[TPanasonicMakerNote.$8001]
TagDescription=Scene mode
0=Off
1=Normal
2=Portrait
3=Scenery
4=Sports
5=Night portrait
6=Programme
7=Aperture priority
8=Shutter priority
9=Macro
10=Spot
11=Manual
12=Movie preview
13=Panning
14=Simple
15=Colour effects
16=Self portrait
17=Economy
18=Fireworks
19=Party
20=Snow
21=Night scenery
22=Food
23=Baby
24=Soft skin
25=Candlelight
26=Starry night
27=High sensitivity
28=Panorama assist
29=Underwater
30=Beach
31=Aerial photo
32=Sunset
33=Pet
34=Intelligent ISO
35=Clipboard
36=High speed continuous shooting
37=Intelligent auto
39=Multi-aspect
41=Transform
42=Flash burst
43=Pin hole
44=Film grain
45=My colour
46=Photo frame
51=HDR

[TPanasonicMakerNote.$8004]
TagDescription=WB red level

[TPanasonicMakerNote.$8005]
TagDescription=WB green level

[TPanasonicMakerNote.$8006]
TagDescription=WB blue level

[TPanasonicMakerNote.$8007]
TagDescription=Flash fired
1=No
2=Yes

[TPanasonicMakerNote.$8008]
TagDescription=Text stamp ($8008)
1=Off
2=On

[TPanasonicMakerNote.$8009]
TagDescription=Text stamp ($8009)
1=Off
2=On

[TPanasonicMakerNote.$8010]
TagDescription=Baby or pet age ($8010)
9999:99:99 00:00:00=(not set)

[TPanasonicMakerNote.$8012]
TagDescription=Transform ($8010)
00000000=Off

; --------------------------------------------------------------------------------------
; Sony - data from http://owl.phy.queensu.ca/~phil/exiftool/TagNames/Sony.html
; --------------------------------------------------------------------------------------

[TSonyMakerNote.$0102]
TagDescription=Quality
0=RAW
1=Super fine
2=Fine
3=Standard
4=Economy
5=Extra fine
6=RAW-JPEG
7=Compressed RAW
8=Compressed RAW-JPEG

[TSonyMakerNote.$0104]
TagDescription=Flash exposure comp.

[TSonyMakerNote.$0105]
TagDescription=Teleconverter
0=None
72=Minolta AF 2x APO (D)
80=Minolta AF 2x APO II
136=Minolta AF 1.4x APO (D)
144=Minolta AF 1.4x APO II

; --------------------------------------------------------------------------------------
; Nikon Type 1 - data from:
; - http://www.ozhiker.com/electronics/pjmt/jpeg_info/nikon_mn.html
; - http://gvsoft.homedns.org/exif/makernote-nikon.html
; --------------------------------------------------------------------------------------
[TNikonType1MakerNote.$0002]
TagDescription=Family ID

[TNikonType1MakerNote.$0003]
TagDescription=Quality
1=VGA (640x480) Basic
2=VGA (640x480) Normal
3=VGA (640x480) Fine
4=SXGA (1280x960) Basic
5=SXGA (1280x960) Normal
6=SXGA (1280x960) Fine
7=XGA (1024x768) Basic
8=XGA (1024x768) Basic
9=XGA (1024x768) Basic
10=UXGA (1600x1200) Basic
11=UXGA (1600x1200) Normal
12=UXGA (1600x1200) Fine
20=(1600x1200) Hi

[TNikonType1MakerNote.$0004]
TagDescription=Colour Mode
1=Colour
2=Monochrome

[TNikonType1MakerNote.$0005]
TagDescription=Image Adjustment
0=Normal
1=Bright+
2=Bright-
3=Contrast+
4=Contrast-
5=Auto

[TNikonType1MakerNote.$0006]
TagDescription=CCD Sensitivity
0=ISO 80
2=ISO 160
4=ISO 320
5=ISO 100

[TNikonType1MakerNote.$0007]
TagDescription=White Balance
0=Auto
1=Preset
2=Daylight
3=Incandescent
4=Fluorescent
5=Cloudy
6=Speedlight (Flash)

[TNikonType1MakerNote.$0008]
TagDescription=Focus

[TNikonType1MakerNote.$000A]
TagDescription=Digital Zoom

[TNikonType1MakerNote.$000B]
TagDescription=Lens Converter
0=No Converter Used
1=Fish-eye Converter Used

[TNikonType1MakerNote.$0F00]
TagDescription=Data Dump

; --------------------------------------------------------------------------------------
; Nikon Type 3 - data from:
; - http://www.ozhiker.com/electronics/pjmt/jpeg_info/nikon_mn.html
; - http://gvsoft.homedns.org/exif/makernote-nikon.html
; - http://www.stefanheymann.de/homegallery/exif-felder.htm
; - http://www.exiv2.org/tags-nikon.html
; - http://search.cpan.org/~exiftool/Image-ExifTool-8.00/lib/Image/ExifTool/TagNames.pod
; - http://owl.phy.queensu.ca/~phil/exiftool/TagNames/Nikon.html
; --------------------------------------------------------------------------------------
[TNikonType3MakerNote.$0001]
TagDescription=Nikon Makernote Version
30323130=2.1

[TNikonType3MakerNote.$0002]
;TagDescription=ISO Speed Used
TagDescription=ISO Speed

[TNikonType3MakerNote.$0003]
TagDescription=Colour Mode

[TNikonType3MakerNote.$0004]
TagDescription=Quality

[TNikonType3MakerNote.$0005]
TagDescription=White Balance

[TNikonType3MakerNote.$0006]
TagDescription=Sharpening

[TNikonType3MakerNote.$0007]
TagDescription=Focus Mode

[TNikonType3MakerNote.$0008]
TagDescription=Flash Setting

[TNikonType3MakerNote.$0009]
TagDescription=Flash Type

[TNikonType3MakerNote.$000B]
TagDescription=White Balance Bias

[TNikonType3MakerNote.$000C]
TagDescription=White Balance RB Coefficients

[TNikonType3MakerNote.$000D]
TagDescription=Program Shift

[TNikonType3MakerNote.$000E]
TagDescription=Exposure Difference

[TNikonType3MakerNote.$000F]
TagDescription=ISO Selection

[TNikonType3MakerNote.$0010]
TagDescription=Data Dump

[TNikonType3MakerNote.$0011]
TagDescription=Thumbnail IFD Offset

[TNikonType3MakerNote.$0012]
TagDescription=Flash Exposure Compensation
6=+1.0 EV
4=+0.7 EV
3=+0.5 EV
2=+0.3 EV
0=0.0 EV
254=-0.3 EV
253=-0.5 EV
252=-0.7 EV
250=-1.0 EV
248=-1.3 EV
247=-1.5 EV
246=-1.7 EV
244=-2.0 EV
242=-2.3 EV
241=-2.5 EV
240=-2.7 EV
238=-3.0 EV

[TNikonType3MakerNote.$0013]
TagDescription=ISO Speed Requested

[TNikonType3MakerNote.$0014]
TagDescription=Color Balance A

[TNikonType3MakerNote.$0016]
TagDescription=Image Boundary

[TNikonType3MakerNote.$0017]
TagDescription=Flash Exposure Compensation

[TNikonType3MakerNote.$0018]
TagDescription=Flash Exposure Bracket Compensation
6=+1.0 EV
4=+0.7 EV
3=+0.5 EV
2=+0.3 EV
0=0.0 EV
254=-0.3 EV
253=-0.5 EV
252=-0.7 EV
250=-1.0 EV
248=-1.3 EV
247=-1.5 EV
246=-1.7 EV
244=-2.0 EV
242=-2.3 EV
241=-2.5 EV
240=-2.7 EV
238=-3.0 EV

[TNikonType3MakerNote.$0019]
TagDescription=Exposure Bracket Compensation Value

[TNikonType3MakerNote.$001A]
TagDescription=Image Processing

[TNikonType3MakerNote.$001B]
TagDescription=Crop Hi Speed

[TNikonType3MakerNote.$001C]
TagDescription=Exposure Tuning

[TNikonType3MakerNote.$001D]
TagDescription=Serial Number

[TNikonType3MakerNote.$001E]
TagDescription=Color Space
1=sRGB
2=AdobeRGB

[TNikonType3MakerNote.$001F]
TagDescription=VR Info

[TNikonType3MakerNote.$0020]
TagDescription=Image Authentication
0=Off
1=On

[TNikonType3MakerNote.$0022]
TagDescription=Active D-lighting
0=Off
1=Low
3=Normal
5=High
7=Extra High
65535=Auto

[TNikonType3MakerNote.$0023]
TagDescription=Picture Control

[TNikonType3MakerNote.$0024]
TagDescription=World Time

[TNikonType3MakerNote.$0025]
TagDescription=ISO Info

[TNikonType3MakerNote.$002A]
TagDescription=Vignette Control
0=Off
1=Low
3=Normal
5=High

[TNikonType3MakerNote.$002B]
TagDescription=Distortion Info

[TNikonType3MakerNote.$0080]
TagDescription=Image Adjustment

[TNikonType3MakerNote.$0081]
TagDescription=Tone Compensation (Contrast)

[TNikonType3MakerNote.$0082]
TagDescription=Auxiliary Lens (Adapter)

[TNikonType3MakerNote.$0083]
TagDescription=Lens Type
0=AF
1=Manual
2=AF-D / AF-S
6=AF-D G
10=AF-D VR
14=AF-S VR

[TNikonType3MakerNote.$0084]
TagDescription=Lens [Min/Max Focal Length , Max Aperture at Min/Max Focal Length]

[TNikonType3MakerNote.$0085]
TagDescription=Manual Focus Distance

[TNikonType3MakerNote.$0086]
TagDescription=Digital Zoom Factor

[TNikonType3MakerNote.$0087]
TagDescription=Flash Mode
0=Did Not Fire
1=Fired, Manual Mode
4=Not Ready
7=Fired, External Flash
8=Fired, Commander Mode
9=Fired, TTL Mode

[TNikonType3MakerNote.$0088]
TagDescription=AF Info

[TNikonType3MakerNote.$0089]
TagDescription=Bracketing & Shooting Mode
0=Single frame, no bracketing
1=Continuous, no bracketing
2=Timer, no bracketing
16=Single frame, exposure bracketing
17=Continuous, exposure bracketing
18=Timer, exposure bracketing
64=Single frame, white balance bracketing
65=Continuous, white balance bracketing
66=Timer, white balance bracketing

[TNikonType3MakerNote.$008A]
TagDescription=Auto Bracket Release

[TNikonType3MakerNote.$008B]
TagDescription=Lens FStops

[TNikonType3MakerNote.$008C]
TagDescription=Tone Curve (Contrast)

[TNikonType3MakerNote.$008D]
TagDescription=Colour Mode

[TNikonType3MakerNote.$008F]
TagDescription=Scene Mode

[TNikonType3MakerNote.$0090]
TagDescription=Light Source

[TNikonType3MakerNote.$0091]
TagDescription=Shot Info

[TNikonType3MakerNote.$0092]
TagDescription=Hue Adjustment

[TNikonType3MakerNote.$0093]
TagDescription=NEF Compression
1=Lossy (type 1)
2=Uncompressed
3=Lossless
4=Lossy (type 2)

[TNikonType3MakerNote.$0094]
TagDescription=Saturation Adjustment
0=None
1=+1
2=+2
65535=-1
65534=-2
65533=Black & White

[TNikonType3MakerNote.$0095]
TagDescription=Noise Reduction

[TNikonType3MakerNote.$0096]
TagDescription=Compression Curve/Linearization Table

[TNikonType3MakerNote.$0097]
TagDescription=Color Balance

[TNikonType3MakerNote.$0098]
TagDescription=Lens Data

[TNikonType3MakerNote.$0099]
TagDescription=Raw Image Center

[TNikonType3MakerNote.$009A]
TagDescription=Sensor Pixel Size

[TNikonType3MakerNote.$009C]
TagDescription=Scene Assist

[TNikonType3MakerNote.$009E]
TagDescription=Retouch History
00000000000000000000=None
0,0,0,0,0=None
0=None
3=B & W
4=Sepia
5=Trim
6=Small Picture
7=D-Lighting
8=Red Eye
9=Cyanotype
10=Sky Light
11=Warm Tone
12=Color Custom
13=Image Overlay
14=Red Intensifier
15=Green Intensifier
16=Blue Intensifier
17=Cross Screen
18=Quick Retouch
19=NEF Processing
23=Distortion Control
25=Fisheye
26=Straighten
29=Perspective Control
30=Color Outline
31=Soft Filter
33=Miniature Effect

[TNikonType3MakerNote.$00A0]
TagDescription=Camera Serial Number

[TNikonType3MakerNote.$00A2]
TagDescription=Image Data Size

[TNikonType3MakerNote.$00A5]
TagDescription=Image Count

[TNikonType3MakerNote.$00A6]
TagDescription=Delete Image Count

[TNikonType3MakerNote.$00A7]
TagDescription=Total Number of Shutter Releases

[TNikonType3MakerNote.$00A8]
TagDescription=Flash Info

[TNikonType3MakerNote.$00A9]
TagDescription=Image Optimisation

[TNikonType3MakerNote.$00AA]
TagDescription=Saturation

[TNikonType3MakerNote.$00AB]
TagDescription=Digital Vari-Program

[TNikonType3MakerNote.$00AC]
TagDescription=Image Stabilization/Vibration Reduction

[TNikonType3MakerNote.$00AD]
TagDescription=AF Response

[TNikonType3MakerNote.$00B0]
TagDescription=Multi Exposure

[TNikonType3MakerNote.$00B1]
TagDescription=High ISO Noise Reduction
0=Off
1=Minimal
2=Low
4=Normal
6=High

[TNikonType3MakerNote.$00B3]
TagDescription=Toning Effect

[TNikonType3MakerNote.$00B6]
TagDescription=Power-Up Time

[TNikonType3MakerNote.$00B7]
TagDescription=AF Info 2

[TNikonType3MakerNote.$00B8]
TagDescription=File Info

[TNikonType3MakerNote.$00B9]
TagDescription=AF Tune

[TNikonType3MakerNote.$00BD]
TagDescription=Picture Control

[TNikonType3MakerNote.$0E00]
TagDescription=PrintIM Info

[TNikonType3MakerNote.$0E01]
TagDescription=Capture Data

[TNikonType3MakerNote.$0E09]
TagDescription=Capture Version

[TNikonType3MakerNote.$0E0E]
TagDescription=Capture Offsets

[TNikonType3MakerNote.$0E10]
TagDescription=Scan IFD

[TNikonType3MakerNote.$0E1D]
TagDescription=ICC Profile

[TNikonType3MakerNote.$0E1E]
TagDescription=Capture Output

; --------------------------------------------------------------------------------------
; Nikon Type 2 - Identical to Nikon Type 3 tag defintions
; --------------------------------------------------------------------------------------
[TNikonType2MakerNote]
UseTagsFrom=TNikonType3MakerNote
