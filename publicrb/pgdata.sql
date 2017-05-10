--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY users (id, name, email, username, password, admin, added_on, modified_on) FROM stdin;
1	Moacir	moacir@blah.com	moacir	$2a$10$h0fSsIaeD/LU4E9w9qqtxOKawBaItGJoPVtgnKGPPw.JT/7aXzLem	t	2015-11-29	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nywalker
--

SELECT pg_catalog.setval('users_id_seq', 1, true);


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY books (id, slug, author, title, isbn, year, url, cover, added_on, modified_on) FROM stdin;
1	let-the-great-world-spin-2009	Colum McCann	Let the Great World Spin	9780812973990	2009	http://books.google.com/books?id=_U8Cv5H-qkEC&dq=isbn:9780812973990&hl=&source=gbs_api	http://books.google.com/books/content?id=_U8Cv5H-qkEC&printsec=frontcover&img=1&zoom=1&edge=none&source=gbs_api	2015-11-29	\N
\.


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nywalker
--

SELECT pg_catalog.setval('books_id_seq', 1, true);


--
-- Data for Name: book_users; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY book_users (book_id, user_id) FROM stdin;
1	1
\.

--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY places (id, slug, name, added_on, lat, lon, confidence, source, geonameid, what3word, bounding_box_string, user_id) FROM stdin;
1	church-street-nyc	Church Street, NYC	2015-11-29	40.7156999999999982	-74.0073000000000008	2	https://en.wikipedia.org/wiki/Church-Street-%28Manhattan%29	\N		\N	1
2	liberty-street-nyc	Liberty Street, NYC	2015-11-29	40.7095330000000004	-74.0113680000000045	2	what3words	\N	ranges.mixer.making	\N	1
3	cortlandt-street-nyc	Cortlandt Street, NYC	2015-11-29	40.7102599999999981	-74.0110130000000055	2	https://en.wikipedia.org/wiki/Cortlandt_Street_%28Manhattan%29	\N	mouse.cook.bike	\N	1
4	west-street-nyc	West Street, NYC	2015-11-29	40.7119309999999999	-74.0143570000000039	2	what3words	\N	buzz.being.leaves	\N	1
5	fulton-street-manhattan-nyc	Fulton Street, Manhattan, NYC	2015-11-29	40.7097189999999998	-74.006842000000006	2	https://en.wikipedia.org/wiki/Fulton_Street_%28Manhattan%29	\N		\N	1
6	vesey-street-nyc	Vesey Street, NYC	2015-11-29	40.7131915000000006	-74.0147503000000029	2	https://en.wikipedia.org/wiki/Vesey_Street	\N		\N	1
7	corner-of-church-and-dey-nyc	Corner of Church and Dey, NYC	2015-11-29	40.7110150000000033	-74.0107990000000058	2	what3words	\N	once.mass.relax	\N	1
8	sam-s-barbershop	Sam’s barbershop	2015-11-29	\N	\N	0		\N		\N	1
9	charlie-s-audio-nyc	Charlie’s Audio, NYC	2015-11-29	\N	\N	0		\N		\N	1
10	saint-paul-s-chapel	Saint Paul’s Chapel	2015-11-29	40.7112100000000012	-74.0093099999999993	3	GeoNames	5135848	merit.chimp.given		1
11	woolworth-building	Woolworth Building	2015-11-29	40.7120499999999979	-74.0084700000000026	3	GeoNames	5145093	wanted.piano.lined		1
12	wall-street-nyc	Wall Street, NYC	2015-11-29	40.7064599999999999	-74.0096520000000027	2	what3words	\N	prep.scars.hidden	\N	1
13	corner-of-dey-and-broadway-nyc	Corner of Dey and Broadway, NYC	2015-11-29	40.7104220000000012	-74.009483000000003	2	what3words	\N	invite.toast.laptop	\N	1
14	meatpacking-district-nyc	Meatpacking District, NYC	2015-11-29	40.7410399999999981	-74.0077200000000062	3	GeoNames	8436471	beats.quiet.metals	[-74.0029716685131, 40.737443540499434, 40.74463845950057, -74.01246833148691]	1
15	battery-park-city-nyc	Battery Park City, NYC	2015-11-29	40.7114899999999977	-74.0162499999999994	3	GeoNames	5108135	foster.bolts.hiding	[-74.0115047766559, 40.70789384049956, 40.71508875950044, -74.0209972233441]	1
16	broadway-downtown-nyc	Broadway, downtown, NYC	2015-11-29	40.7057059999999993	-74.0133500000000026	2	what3words	\N	paints.leaps.force	\N	1
17	world-trade-center-plaza-nyc	World Trade Center Plaza, NYC	2015-11-29	40.7115539999999996	-74.0133260000000064	2	what3words	\N	privately.define.copy	\N	1
18	twin-towers-nyc	Twin Towers, NYC	2015-11-29	40.7115810000000025	-74.0132899999999978	2	what3words	\N	leader.ducks.poppy	\N	1
19	federal-office-building-nyc	Federal Office Building, NYC	2015-11-29	\N	\N	0		\N		\N	1
20	hudson-river-ny	Hudson River, NY	2015-11-29	40.7030559999999966	-74.0261110000000002	2	https://en.wikipedia.org/wiki/Hudson_River	\N		\N	1
21	west-side-highway-nyc	West Side Highway, NYC	2015-11-29	40.7538410000000013	-74.0071400000000068	2	what3words	\N	stable.double.overnight	\N	1
22	west-side-of-the-towers	west side of the towers	2015-11-29	40.7117700000000013	-74.0139659999999964	2	what3words	\N	digits.pose.dream	\N	1
23	world-trade-center-south	World Trade Center South	2015-11-29	40.7110150000000033	-74.0130759999999981	2	what3words	\N	update.logs.doors	\N	1
24	title-guarantee-100-church-nyc	Title Guarantee, 100 Church, NYC	2015-11-29	40.713279	-74.010122999999993	2	what3words	\N	trap.cling.pile	\N	1
25	john-street-nyc	John Street, NYC	2015-11-29	40.7082203000000007	-74.007696199999998	2	Google Maps	\N		\N	1
26	nassau-street-nyc	Nassau Street, NYC	2015-11-29	40.7098020000000034	-74.0081310000000059	2	what3words	\N	toned.ankle.rust	\N	1
27	dublin	Dublin	2015-11-29	53.3330600000000032	-6.24889000000000028	3	GeoNames	2964574	swaps.string.bland	[-6.028277395819914, 53.201721011004274, 53.464390988995724, -6.469500604180086]	1
28	dublin-bay	Dublin Bay	2015-11-29	53.3344400000000007	-6.11056000000000044	3	GeoNames	2964571	clocks.ally.decide		1
29	sandymount	Sandymount	2015-11-29	53.3350000000000009	-6.21138999999999974	3	GeoNames	2961589	nets.bake.stars	[-6.191459077322275, 53.32310252101233, 53.34689747898767, -6.231318722677726]	1
30	martello-tower-sandycove	Martello Tower, Sandycove	2015-11-29	53.2886620000000022	-6.11365900000000018	2	what3words	\N	ramble.slouches.preoccupied	\N	1
31	forty-foot	Forty Foot	2015-11-29	53.2894429999999986	-6.11383899999999958	2	https://en.wikipedia.org/wiki/Forty_Foot	\N	saluting.bailer.contending	\N	1
32	dun-laoghaire	Dún Laoghaire	2015-11-29	53.2939500000000024	-6.13586000000000009	3	GeoNames	2964506	medium.total.nests	[-6.042378835877699, 53.238147501755066, 53.34975574764695, -6.229349679747301]	1
33	london	London	2015-11-29	51.5085300000000004	-0.125739999999999991	3	GeoNames	2643743	thing.then.link	[0.45212493672385795, 51.15168939834484, 51.865368153380956, -0.7036088539601859]	1
34	oxford	Oxford	2015-11-29	51.7522200000000012	-1.25595999999999997	3	GeoNames	2640729	arena.draw.member	[-1.1736859365559815, 51.70134524242165, 51.80309676273755, -1.3382349923990984]	1
35	ringsend-dublin	Ringsend, Dublin	2015-11-29	53.341940000000001	-6.22639000000000031	3	GeoNames	2961816	just.maybe.quench	[-6.207934845618277, 53.33092947481659, 53.35295932518341, -6.244842954381723]	1
36	grand-canal-dublin	Grand Canal, Dublin	2015-11-29	53.3390600000000035	-6.23913100000000043	2	what3words	\N	desire.runner.wishes	\N	1
37	new-york-city	New York City	2015-11-29	40.7142699999999991	-74.0059700000000049	3	GeoNames	5128581	elder.curving.fingernails	[-73.51356268564581, 40.34312441457063, 41.085413785429374, -74.4983831143542]	1
38	blackrock-dublin	Blackrock, Dublin	2015-11-29	53.3014999999999972	-6.1778000000000004	3	GeoNames	2966131	other.held.boost	[-6.157885821619092, 53.28960252101233, 53.31339747898767, -6.197714178380909]	1
39	frenchman-s-lane-dublin	Frenchman’s Lane, Dublin	2015-11-29	53.3502938000000029	-6.25538659999999958	2	Google Maps	\N		\N	1
40	spencer-row-dublin	Spencer Row, Dublin	2015-11-29	53.3506331999999972	-6.25466280000000019	2	Google Maps	\N		\N	1
41	rutland-street-dublin	Rutland Street, Dublin	2015-11-29	53.3548463999999996	-6.25432789999999983	2	Google Maps	\N		\N	1
42	ireland	Ireland	2015-11-29	53	-8	3	GeoNames	2963597	flattening.emulation.railing	[-6.002389, 51.424557, 55.436501, -10.618111]	1
43	river-liffey	River Liffey	2015-11-29	53.345559999999999	-6.21694000000000013	3	GeoNames	2962947	votes.also.adults		1
44	irishtown-road	Irishtown Road	2015-11-29	53.3367555999999965	-6.22904329999999984	2	Google Maps	\N		\N	1
45	beach-road-dublin	Beach Road, Dublin	2015-11-29	53.3356907000000007	-6.21850069999999988	2	Google Maps	\N		\N	1
46	st-vincent-s-university-hospital	St. Vincent’s University Hospital	2015-11-29	53.3181498000000005	-6.23648419999999959	2	Google Maps	\N		\N	1
47	merrion-road-dublin	Merrion Road, Dublin	2015-11-29	53.3253600000000034	-6.2229000000000001	3	GeoNames	8642952	shield.twins.shower		1
48	assisi	Assisi	2015-11-29	43.0667100000000005	12.6210900000000006	3	GeoNames	3182722	orders.sketches.these	[12.63462348224774, 43.053742902939234, 43.07565694337934, 12.603992079825906]	1
49	hiroshima	Hiroshima	2015-11-29	34.3999999999999986	132.449999999999989	3	GeoNames	1862415	fells.workouts.sting	[132.61852372866568, 34.26117989237973, 34.53882010762027, 132.2814762713343]	1
50	leinster-house-dublin	Leinster House, Dublin	2015-11-29	53.340600000000002	-6.25417000000000023	3	GeoNames	6949200	foster.still.magma		1
51	kildare-street-dublin	Kildare Street, Dublin	2015-11-29	53.3433330000000012	-6.25555600000000034	2	https://en.wikipedia.org/wiki/Kildare_Street	\N		\N	1
52	emo-college	Emo College	2015-11-29	\N	\N	0		\N		\N	1
53	river-barrow	River Barrow	2015-11-29	52.23583	-6.95999999999999996	3	GeoNames	2966310	shepherds.mistreat.disapproval		1
54	laois	Laois	2015-11-29	53	-7.40000000000000036	3	GeoNames	2963031	loved.drastic.them		1
55	brussels	Brussels	2015-11-29	50.8504500000000021	4.34877999999999965	3	GeoNames	2800866	itself.decades.toasted	[4.556903881208461, 50.719418364785014, 50.981471745733586, 4.14066310487552]	1
56	napoli	Napoli	2015-11-29	40.8563100000000006	14.2464099999999991	3	GeoNames	3172394	tougher.sitting.effort	[14.353706635782626, 40.79189029136584, 40.9159323529191, 14.139429097169932]	1
57	quartieri-spagnoli-naples	Quartieri Spagnoli, Naples	2015-11-29	40.8408330000000035	14.2463890000000006	2	https://en.wikipedia.org/wiki/Quartieri_Spagnoli	\N		\N	1
59	raglan-road-dublin	Raglan Road, Dublin	2015-11-29	53.3303000000000011	-6.23819999999999997	2	https://en.wikipedia.org/wiki/Raglan_Road,_Dublin	\N		\N	1
60	dandelion-market-dublin	Dandelion Market, Dublin	2015-11-29	53.3399769999999975	-6.26227	2	what3words	\N	agrees.open.reject	\N	1
61	leinster-street-south	Leinster Street South	2015-11-29	53.3419999999999987	-6.25582559999999965	2	Google Maps	\N		\N	1
62	molesworth-street-dublin	Molesworth Street, Dublin	2015-11-29	53.341148699999998	-6.25924179999999986	2	Google Maps	\N		\N	1
63	dawson-street-dublin	Dawson Street, Dublin	2015-11-29	53.3409844000000035	-6.26053090000000001	2	Google Maps	\N		\N	1
64	john-f-kennedy-international-airport	John F Kennedy International Airport	2015-11-29	40.6398300000000035	-73.7787399999999991	3	GeoNames	5122732	thank.safety.empire		1
65	125th-street-mta-station-4-5-6-nyc	125th Street MTA Station (4, 5, 6), NYC	2015-11-29	40.8043740000000028	-73.937375000000003	2	what3words	\N	encounter.supply.finds	\N	1
66	the-bronx	The Bronx	2015-11-29	40.8498500000000035	-73.8664100000000019	3	GeoNames	5110266	filer.sound.tones	[-73.66398885133725, 40.697092460050406, 41.00261188400756, -74.06882212278384]	1
67	grand-concourse-nyc	Grand Concourse, NYC	2015-11-29	40.8305560000000014	-73.9208330000000018	2	https://en.wikipedia.org/wiki/Grand_Concourse_%28Bronx%29	\N		\N	1
68	south-bronx-nyc	South Bronx, NYC	2015-11-29	40.8162099999999981	-73.917349999999999	2	https://en.wikipedia.org/wiki/South_Bronx	\N		\N	1
69	chumley-s	Chumley’s	2015-11-29	40.732056	-74.0051389999999998	2	https://en.wikipedia.org/wiki/Chumley's	\N		\N	1
70	greenwich-village	Greenwich Village	2015-11-29	40.7284399999999991	-74.0029200000000031	3	GeoNames	5119418	toned.allows.yard	[-73.99104775784562, 40.719441751248574, 40.73742904875143, -74.01478684215436]	1
71	brooklyn-bridge	Brooklyn Bridge	2015-11-29	40.7053799999999981	-73.9962500000000034	3	GeoNames	5110306	bowls.needed.wage		1
72	central-park-nyc	Central Park, NYC	2015-11-29	40.7823199999999986	-73.9654199999999946	3	GeoNames	5112085	comb.bared.repair		1
73	cypress-avenue-bronx-nyc	Cypress Avenue, Bronx, NYC	2015-11-29	40.807065999999999	-73.9154091000000051	2	Google Maps	\N		\N	1
74	st-mary-s-playground-bronx-nyc	St. Mary’s Playground, Bronx, NYC	2015-11-29	40.8099083999999976	-73.9141955000000053	2	Google Maps	\N		\N	1
75	hungary	Hungary	2015-11-29	47	20	3	GeoNames	719819	geologist.deregulated.tightrope	[22.906, 45.74361, 48.585667, 16.111889]	1
76	gaillimh-galway	Gaillimh (Galway)	2015-11-29	53.2719400000000007	-9.0488900000000001	3	GeoNames	2964180	belly.daisy.wizard	[-8.991575879150025, 53.23769720585764, 53.30619079414235, -9.106202120849977]	1
77	major-deegan-expressway	Major Deegan Expressway	2015-11-29	40.8620743999999974	-73.9145774999999929	2	Google Maps	\N		\N	1
78	copacabana-nightclub-nyc	Copacabana Nightclub, NYC	2015-11-29	40.7644049999999964	-73.9718840000000029	2	what3words	\N	uses.over.forms	\N	1
79	switzerland	Switzerland	2015-11-29	47.000160000000001	8.01426999999999978	3	GeoNames	2658434	bound.vampire.spellings	[10.491472, 45.825695, 47.805332, 5.957472]	1
80	geneve-geneva	Genève (Geneva)	2015-11-29	46.202219999999997	6.1456900000000001	3	GeoNames	2660646	worker.starred.blubber	[6.175857025961564, 46.17777227675371, 46.23188430488219, 6.110241808578824]	1
81	california	California	2015-11-29	37.2502199999999988	-119.751260000000002	3	GeoNames	5332921	surgical.everyone.unrest	[-114.131211, 32.528832, 42.009516999999995, -124.48200299999999]	1
82	belfast	Belfast	2015-11-29	54.596820000000001	-5.92541000000000029	3	GeoNames	2655984	organ.beats.jabs	[-5.80800810592701, 54.52891944095775, 54.66472055904225, -6.04281189407299]	1
83	federative-republic-of-brazil	Federative Republic of Brazil	2015-11-29	-10	-55	3	GeoNames	3469034		[-28.839052, -33.750706, 5.264877, -73.985535]	1
84	saint-ann-s-episcopal-church	Saint Ann’s Episcopal Church	2015-11-29	40.8084300000000013	-73.916799999999995	2	GeoNames	5134906	puts.state.giant		1
85	willis-avenue	Willis Avenue	2015-11-29	40.8104075999999978	-73.9241331000000059	2	Google Maps	\N		\N	1
86	united-states	United States	2015-11-29	39.759999999999998	-98.5	3	GeoNames	6252001	folks.boosted.listens	[-66.954811, 18.913685, 71.390656, 172.454697]	1
87	democratic-republic-of-the-congo	Democratic Republic of the Congo	2015-11-29	-2.5	23.5	3	GeoNames	203312	clippers.overshadow.banjos	[31.305912, -13.455675, 5.386098, 12.204144]	1
88	republic-of-guatemala	Republic of Guatemala	2015-11-29	15.5	-90.25	3	GeoNames	3595528	administrator.cones.february	[-88.223198, 13.737302, 17.81522, -92.23629]	1
89	long-island-ny	Long Island, NY	2015-11-29	40.8167699999999982	-73.0662200000000013	3	GeoNames	5125123	slimy.leaps.drives	[-72.239449, 40.548725, 41.161514, -74.04628]	1
90	montauk-ny	Montauk, NY	2015-11-29	41.0359399999999965	-71.9545099999999991	3	GeoNames	5127321	stalemate.decades.rubbing	[-71.9460828062149, 41.02957582998025, 41.042294770019744, -71.96294639378509]	1
91	central-america	Central America	2015-11-29	25.3241699999999987	-99.6679699999999968	3	GeoNames	7729892	softballs.heartbeats.product	[-77.17411, 5.499074, 32.716759, -118.453949]	1
92	borough-of-queens-nyc	Borough of Queens, NYC	2015-11-29	40.6814899999999966	-73.836519999999993	3	GeoNames	5133273	salsa.brick.terms	[-73.5777656932915, 40.485841577769555, 40.87714282223045, -74.09528150670852]	1
93	carlow	Carlow	2015-11-29	52.8408299999999969	-6.92611000000000043	3	GeoNames	2965768	bolt.rapid.hampers	[-6.896320005352376, 52.822846002497144, 52.858820597502856, -6.955902194647624]	1
94	ciarrai-county-kerry	Ciarraí (County Kerry)	2015-11-29	52.1666700000000034	-9.75	3	GeoNames	2963517	siesta.dittos.forever		1
95	county-limerick	County Limerick	2015-11-29	52.5	-8.75	3	GeoNames	2962941	flint.manufacture.remaining		1
96	county-cork	County Cork	2015-11-29	51.9666700000000006	-8.58333000000000013	3	GeoNames	2965139	saving.soaks.recklessly		1
97	republic-of-france	Republic of France	2015-11-29	46	2	3	GeoNames	3017382	harmless.jazz.brawn	[9.561556, 41.338779, 51.092804, -5.142222]	1
98	east-side-manhattan	East Side, Manhattan	2015-11-29	40.75	-73.980000000000004	2	https://en.wikipedia.org/wiki/East_Side_%28Manhattan%29	\N		\N	1
99	manhattan	Manhattan	2015-11-29	40.7834300000000027	-73.9662500000000023	3	GeoNames	5125771	washed.heap.debit	[-73.75670410356709, 40.625148837009355, 40.94172016299064, -74.17579489643292]	1
100	west-side-manhattan	West Side, Manhattan	2015-11-29	40.7879999999999967	-73.9779999999999944	2	https://en.wikipedia.org/wiki/West_Side_%28Manhattan%29	\N		\N	1
101	the-sherry-netherland-hotel-nyc	The Sherry-Netherland Hotel, NYC	2015-11-29	40.7643789999999981	-73.9727029999999957	2	what3words	\N	boom.liked.hills	\N	1
102	manhattan-house-of-detention	Manhattan House of Detention	2015-11-29	40.7165669999999977	-74.000479999999996	2	what3words	\N	drops.mock.courier	\N	1
103	centre-street-nyc	Centre Street, NYC	2015-11-29	40.7173889999999972	-74.0004529999999932	2	https://en.wikipedia.org/wiki/Centre_Street_%28Manhattan%29	\N		\N	1
104	hunts-point-bronx-nyc	Hunts Point, Bronx, NYC	2015-11-29	40.8126000000000033	-73.8840200000000067	3	GeoNames	5121666	fast.snow.driven	[-73.87214010889858, 40.80360715124857, 40.821594448751426, -73.89590929110142]	1
105	lower-manhattan	Lower Manhattan	2015-11-29	40.7077999999999989	-74.0118999999999971	2	https://en.wikipedia.org/wiki/Lower_Manhattan	\N		\N	1
106	franklin-d-roosevelt-east-river-drive	Franklin D. Roosevelt East River Drive	2015-11-29	40.7398918000000023	-73.974911800000001	2	https://en.wikipedia.org/wiki/Franklin_D._Roosevelt_East_River_Drive	\N		\N	1
107	east-river	East River	2015-11-29	40.7870500000000007	-73.9176400000000058	3	GeoNames	5116041	slap.form.improving		1
108	metropolitan-hospital-center-nyc	Metropolitan Hospital Center, NYC	2015-11-29	40.7849000000000004	-73.9448100000000039	3	GeoNames	5126697	cheek.cards.grand		1
\.


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nywalker
--

SELECT pg_catalog.setval('places_id_seq', 108, true);

--
-- Data for Name: instances; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY instances (id, page, sequence, text, added_on, modified_on, place_id, user_id, book_id) FROM stdin;
1	3	1	Church Street	2015-11-29	\N	1	1	1
2	3	2	Liberty	2015-11-29	\N	2	1	1
3	3	3	Cortlandt	2015-11-29	\N	3	1	1
4	3	4	West Street	2015-11-29	\N	4	1	1
5	3	5	Fulton	2015-11-29	\N	5	1	1
6	3	6	Vesey	2015-11-29	\N	6	1	1
7	4	1	corner of Church and Dey	2015-11-29	\N	7	1	1
8	4	2	Sam’s barbershop	2015-11-29	\N	8	1	1
9	4	3	Charlie’s Audio	2015-11-29	\N	9	1	1
10	4	4	St. Paul’s Chapel	2015-11-29	\N	10	1	1
11	4	5	Woolworth Building	2015-11-29	\N	11	1	1
12	4	6	Wall Street	2015-11-29	\N	12	1	1
13	4	7	corner of Dey and Broadway	2015-11-29	\N	13	1	1
14	4	8	West	2015-11-29	\N	4	1	1
15	4	9	meat-packing warehouses on the West Side	2015-11-29	\N	14	1	1
16	4	10	high-rises in Battery Park	2015-11-29	\N	15	1	1
17	4	11	Broadway	2015-11-29	\N	16	1	1
18	4	12	the plaza below	2015-11-29	\N	17	1	1
19	4	13	the towers themselves	2015-11-29	\N	18	1	1
20	5	1	Federal Office Building	2015-11-29	\N	19	1	1
21	5	2	Hudson	2015-11-29	\N	20	1	1
22	5	3	warehouses of the West Side	2015-11-29	\N	14	1	1
23	5	4	West Side Highway	2015-11-29	\N	21	1	1
24	6	1	west side of the towers	2015-11-29	\N	22	1	1
25	6	2	foyer of the World Trade Center	2015-11-29	\N	23	1	1
26	6	3	Home Title Guarantee Company	2015-11-29	\N	24	1	1
27	6	4	Church Street	2015-11-29	\N	1	1	1
28	6	5	Fulton	2015-11-29	\N	5	1	1
29	6	6	Broadway	2015-11-29	\N	16	1	1
30	6	7	John	2015-11-29	\N	25	1	1
31	6	8	Nassau	2015-11-29	\N	26	1	1
32	11	1	Dublin	2015-11-29	\N	27	1	1
33	12	1	Dublin Bay	2015-11-29	\N	28	1	1
34	12	2	Sandymount	2015-11-29	\N	29	1	1
35	12	3	Dublin	2015-11-29	\N	27	1	1
36	12	4	Martello Tower	2015-11-29	\N	30	1	1
37	12	5	abandoned public baths	2015-11-29	\N	31	1	1
38	12	6	Dun Laoghaire	2015-11-29	\N	32	1	1
39	12	7	Dublin Bay	2015-11-29	\N	28	1	1
40	12	8	London	2015-11-29	\N	33	1	1
41	12	9	Oxford	2015-11-29	\N	34	1	1
42	14	1	Ringsend	2015-11-29	\N	35	1	1
43	15	1	canal	2015-11-29	\N	36	1	1
44	15	2	New York	2015-11-29	\N	37	1	1
45	15	3	Blackrock	2015-11-29	\N	38	1	1
46	15	4	Frenchman’s Lane	2015-11-29	\N	39	1	1
47	15	5	Spencer Row	2015-11-29	\N	40	1	1
48	16	1	Rutland Street	2015-11-29	\N	41	1	1
49	16	2	Ireland	2015-11-29	\N	42	1	1
50	16	3	Dublin	2015-11-29	\N	27	1	1
51	17	1	Liffey	2015-11-29	\N	43	1	1
52	17	2	Ringsend	2015-11-29	\N	35	1	1
53	17	3	Irishtown Road	2015-11-29	\N	44	1	1
54	17	4	Beach Road	2015-11-29	\N	45	1	1
55	18	1	St. Vincent’s Hospital	2015-11-29	\N	46	1	1
56	19	1	Merrion Road	2015-11-29	\N	47	1	1
57	21	1	Assisi	2015-11-29	\N	48	1	1
58	21	2	Dublin	2015-11-29	\N	27	1	1
59	21	3	Hiroshima	2015-11-29	\N	49	1	1
60	21	4	Parliament	2015-11-29	\N	50	1	1
61	21	5	Kildare Street	2015-11-29	\N	51	1	1
62	21	6	Emo College	2015-11-29	\N	52	1	1
63	21	7	Barrow River	2015-11-29	\N	53	1	1
64	21	8	Laois	2015-11-29	\N	54	1	1
65	21	9	Brussels	2015-11-29	\N	55	1	1
66	22	1	Brussels	2015-11-29	\N	55	1	1
67	22	2	Naples	2015-11-29	\N	56	1	1
68	22	3	Spanish Quarter	2015-11-29	\N	57	1	1
69	22	4	New York	2015-11-29	\N	37	1	1
70	22	5	New York	2015-11-29	\N	37	1	1
71	22	6	Raglan Road	2015-11-29	\N	59	1	1
72	22	7	Dandelion Market	2015-11-29	\N	60	1	1
73	22	8	Dublin	2015-11-29	\N	27	1	1
74	22	9	South Leinster Street	2015-11-29	\N	61	1	1
75	22	10	Kildare Street	2015-11-29	\N	51	1	1
76	22	11	Molesworth Street	2015-11-29	\N	62	1	1
77	23	1	Dawson Street	2015-11-29	\N	63	1	1
78	23	2	John F. Kennedy Airport	2015-11-29	\N	64	1	1
79	23	3	Ireland	2015-11-29	\N	42	1	1
80	23	4	125th Street	2015-11-29	\N	65	1	1
81	23	5	the Bronx	2015-11-29	\N	66	1	1
82	23	6	Concourse	2015-11-29	\N	67	1	1
83	26	1	New York	2015-11-29	\N	37	1	1
84	30	1	Bronx	2015-11-29	\N	66	1	1
85	32	1	Dublin	2015-11-29	\N	27	1	1
86	32	2	Dublin	2015-11-29	\N	27	1	1
87	32	3	South Bronx	2015-11-29	\N	68	1	1
88	32	4	Chumley’s bar	2015-11-29	\N	69	1	1
89	32	5	Village	2015-11-29	\N	70	1	1
90	32	6	Brooklyn Bridge	2015-11-29	\N	71	1	1
91	32	7	Central Park	2015-11-29	\N	72	1	1
92	32	8	Cypress Avenue	2015-11-29	\N	73	1	1
93	33	1	St. Mary’s	2015-11-29	\N	74	1	1
94	34	1	Hungary	2015-11-29	\N	75	1	1
95	34	2	the Bronx	2015-11-29	\N	66	1	1
96	34	3	Sandymount	2015-11-29	\N	29	1	1
97	35	1	Galway	2015-11-29	\N	76	1	1
98	35	2	Major Deegan	2015-11-29	\N	77	1	1
99	36	1	Copacabana	2015-11-29	\N	78	1	1
100	36	2	Switzerland	2015-11-29	\N	79	1	1
101	37	1	Geneva	2015-11-29	\N	80	1	1
102	37	2	California	2015-11-29	\N	81	1	1
103	37	3	Ireland	2015-11-29	\N	42	1	1
104	37	4	Belfast	2015-11-29	\N	82	1	1
105	37	5	Brazil	2015-11-29	\N	83	1	1
106	41	1	the church on St. Ann’s	2015-11-29	\N	84	1	1
107	42	1	Dublin	2015-11-29	\N	27	1	1
108	42	2	the Deegan	2015-11-29	\N	77	1	1
109	44	1	Galway	2015-11-29	\N	76	1	1
111	45	1	the Bronx	2015-11-29	\N	66	1	1
112	45	2	Sandymount	2015-11-29	\N	29	1	1
113	45	3	Dublin	2015-11-29	\N	27	1	1
114	45	4	Ireland	2015-11-29	\N	42	1	1
115	48	1	South Bronx	2015-11-29	\N	68	1	1
116	48	2	Willis	2015-11-29	\N	85	1	1
117	48	3	America	2015-11-29	\N	86	1	1
118	49	1	Zaire	2015-11-29	\N	87	1	1
119	49	2	Guatemala	2015-11-29	\N	88	1	1
120	50	1	St. Ann’s	2015-11-29	\N	84	1	1
121	51	1	Long Island	2015-11-29	\N	89	1	1
122	51	2	Montauk	2015-11-29	\N	90	1	1
123	52	1	Ireland	2015-11-29	\N	42	1	1
124	53	1	the Bronx	2015-11-29	\N	66	1	1
125	54	1	Guatemala	2015-11-29	\N	88	1	1
126	55	1	Guatemala	2015-11-29	\N	88	1	1
127	55	2	Central America	2015-11-29	\N	91	1	1
128	57	1	the Bronx	2015-11-29	\N	66	1	1
129	58	1	Queens	2015-11-29	\N	92	1	1
131	59	2	Kerry	2015-11-29	\N	94	1	1
130	59	1	Carlow	2015-11-29	\N	93	1	1
132	59	3	Limerick	2015-11-29	\N	95	1	1
133	59	4	Cork	2015-11-29	\N	96	1	1
134	59	5	Kerry	2015-11-29	\N	94	1	1
135	59	6	France	2015-11-29	\N	97	1	1
136	59	7	Concourse	2015-11-29	\N	67	1	1
137	59	8	the Bronx	2015-11-29	\N	66	1	1
138	59	9	village	2015-11-29	\N	70	1	1
139	59	10	East Side	2015-11-29	\N	98	1	1
140	59	11	Manhattan	2015-11-29	\N	99	1	1
141	59	12	Concourse	2015-11-29	\N	67	1	1
142	60	1	Sherry-Netherlands	2015-11-29	\N	101	1	1
143	60	2	the Deegan	2015-11-29	\N	77	1	1
144	63	1	Manhattan	2015-11-29	\N	99	1	1
145	63	2	the Bronx	2015-11-29	\N	66	1	1
146	63	3	Manhattan	2015-11-29	\N	99	1	1
147	64	1	The Tombs	2015-11-29	\N	102	1	1
148	64	2	Centre Street	2015-11-29	\N	103	1	1
149	64	3	Queens	2015-11-29	\N	92	1	1
150	64	4	Hunts Point	2015-11-29	\N	104	1	1
151	65	1	Manhattan	2015-11-29	\N	99	1	1
152	65	2	Long Island	2015-11-29	\N	89	1	1
153	68	1	Dublin	2015-11-29	\N	27	1	1
154	69	1	the Tombs	2015-11-29	\N	102	1	1
155	69	2	lower Manhattan	2015-11-29	\N	105	1	1
156	69	3	the FDR	2015-11-29	\N	106	1	1
157	69	4	East River	2015-11-29	\N	107	1	1
158	70	1	East Side	2015-11-29	\N	98	1	1
159	70	2	Metropolitan Hospital	2015-11-29	\N	108	1	1
160	70	3	The Bronx	2015-11-29	\N	66	1	1
161	70	4	Metropolitan Hospital	2015-11-29	\N	108	1	1
162	70	5	Queens	2015-11-29	\N	92	1	1
\.


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nywalker
--

SELECT pg_catalog.setval('instances_id_seq', 162, true);


--
-- Data for Name: nicknames; Type: TABLE DATA; Schema: public; Owner: nywalker
--

COPY nicknames (id, name, place_id) FROM stdin;
1	Church Street, NYC	1
2	Church Street	1
3	Liberty Street, NYC	2
4	Liberty	2
5	Cortlandt Street, NYC	3
6	Cortlandt	3
7	West Street, NYC	4
8	West Street	4
9	Fulton Street, Manhattan, NYC	5
10	Fulton	5
11	Vesey Street, NYC	6
12	Vesey	6
13	Corner of Church and Dey, NYC	7
14	corner of Church and Dey	7
15	Sam’s barbershop	8
16	Charlie’s Audio, NYC	9
17	Charlie’s Audio	9
18	Saint Paul’s Chapel	10
19	St. Paul’s Chapel	10
20	Woolworth Building	11
21	Wall Street, NYC	12
22	Wall Street	12
23	Corner of Dey and Broadway, NYC	13
24	corner of Dey and Broadway	13
25	West	4
26	Meatpacking District, NYC	14
27	meat-packing warehouses on the West Side	14
28	Battery Park City, NYC	15
29	high-rises in Battery Park	15
30	Broadway, downtown, NYC	16
31	Broadway	16
32	World Trade Center Plaza, NYC	17
33	the plaza below	17
34	Twin Towers, NYC	18
35	the towers themselves	18
36	Federal Office Building, NYC	19
37	Federal Office Building	19
38	Hudson River, NY	20
39	Hudson	20
40	warehouses of the West Side	14
41	West Side Highway, NYC	21
42	West Side Highway	21
43	west side of the towers	22
44	World Trade Center South	23
45	foyer of the World Trade Center	23
46	Title Guarantee, 100 Church, NYC	24
47	Home Title Guarantee Company	24
48	John Street, NYC	25
49	John	25
50	Nassau Street, NYC	26
51	Nassau	26
52	Dublin	27
53	Dublin Bay	28
54	Sandymount	29
55	Martello Tower, Sandycove	30
56	Martello Tower	30
57	Forty Foot	31
58	abandoned public baths	31
59	Dún Laoghaire	32
60	Dun Laoghaire	32
61	London	33
62	Oxford	34
63	Ringsend, Dublin	35
64	Ringsend	35
65	Grand Canal, Dublin	36
66	canal	36
67	New York City	37
68	New York	37
69	Blackrock, Dublin	38
70	Blackrock	38
71	Frenchman’s Lane, Dublin	39
72	Frenchman’s Lane	39
73	Spencer Row, Dublin	40
74	Spencer Row	40
75	Rutland Street, Dublin	41
76	Rutland Street	41
77	Ireland	42
78	River Liffey	43
79	Liffey	43
80	Irishtown Road	44
81	Beach Road, Dublin	45
82	Beach Road	45
83	St. Vincent’s University Hospital	46
84	St. Vincent’s Hospital	46
85	Merrion Road, Dublin	47
86	Merrion Road	47
87	Assisi	48
88	Hiroshima	49
89	Leinster House, Dublin	50
90	Parliament	50
91	Kildare Street, Dublin	51
92	Kildare Street	51
93	Emo College	52
94	River Barrow	53
95	Barrow River	53
96	Laois	54
97	Brussels	55
98	Napoli	56
99	Naples	56
100	Quartieri Spagnoli, Naples	57
101	Spanish Quarter	57
103	Raglan Road, Dublin	59
104	Raglan Road	59
105	Dandelion Market, Dublin	60
106	Dandelion Market	60
107	Leinster Street South	61
108	South Leinster Street	61
109	Molesworth Street, Dublin	62
110	Molesworth Street	62
111	Dawson Street, Dublin	63
112	Dawson Street	63
113	John F Kennedy International Airport	64
114	John F. Kennedy Airport	64
115	125th Street MTA Station (4, 5, 6), NYC	65
116	125th Street	65
117	The Bronx	66
118	the Bronx	66
119	Grand Concourse, NYC	67
120	Concourse	67
121	Bronx	66
122	South Bronx, NYC	68
123	South Bronx	68
124	Chumley’s	69
125	Chumley’s bar	69
126	Greenwich Village	70
127	Village	70
128	Brooklyn Bridge	71
129	Central Park, NYC	72
130	Central Park	72
131	Cypress Avenue, Bronx, NYC	73
132	Cypress Avenue	73
133	St. Mary’s Playground, Bronx, NYC	74
134	St. Mary’s	74
135	Hungary	75
136	Gaillimh (Galway)	76
137	Galway	76
138	Major Deegan Expressway	77
139	Major Deegan	77
140	Copacabana Nightclub, NYC	78
141	Copacabana	78
142	Switzerland	79
143	Genève (Geneva)	80
144	Geneva	80
145	California	81
146	Belfast	82
147	Federative Republic of Brazil	83
148	Brazil	83
149	Saint Ann’s Episcopal Church	84
150	the church on St. Ann’s	84
151	the Deegan	77
152	Willis Avenue	85
153	Willis	85
154	United States	86
155	America	86
156	Democratic Republic of the Congo	87
157	Zaire	87
158	Republic of Guatemala	88
159	Guatemala	88
160	St. Ann’s	84
161	Long Island, NY	89
162	Long Island	89
163	Montauk, NY	90
164	Montauk	90
165	Central America	91
166	Borough of Queens, NYC	92
167	Queens	92
168	Carlow	93
169	Ciarraí (County Kerry)	94
170	Kerry	94
171	County Limerick	95
172	Limerick	95
173	County Cork	96
174	Cork	96
175	Republic of France	97
176	France	97
177	village	70
178	East Side, Manhattan	98
179	East Side	98
180	Manhattan	99
181	West Side, Manhattan	100
182	The Sherry-Netherland Hotel, NYC	101
183	Sherry-Netherlands	101
184	Manhattan House of Detention	102
185	The Tombs	102
186	Centre Street, NYC	103
187	Centre Street	103
188	Hunts Point, Bronx, NYC	104
189	Hunts Point	104
190	the Tombs	102
191	Lower Manhattan	105
192	lower Manhattan	105
193	Franklin D. Roosevelt East River Drive	106
194	the FDR	106
195	East River	107
196	Metropolitan Hospital Center, NYC	108
197	Metropolitan Hospital	108
\.


--
-- Name: nicknames_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nywalker
--

SELECT pg_catalog.setval('nicknames_id_seq', 197, true);

