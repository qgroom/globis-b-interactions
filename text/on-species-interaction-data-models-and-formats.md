## On species interaction data models and data formats.

(early draft)

A data model is a conceptual representation of pieces of information and how their relate to each other. A data format is used to physically store information. In the following section, we discuss commonly used species interaction data models and propose a model that is best suited to deal with the complex nature of species interaction data. Following, we discuss some data formats and propose best practices for publishing species interaction datasets. 

### Species Interaction Data Models.

Existing species interaction data models can be categorized in pairwise, n-ary and network interaction models. The table (XXX) of GloBI’s registry of existing species interaction datasets provides examples on how species interaction data are modeled and capture in digital data formats. 

!(pairwise)[https://raw.githubusercontent.com/jhpoelen/globis-b-interactions/master/figures/pairwise.png]

Pairwise data models describe an interaction as an association between two taxa, two individual organisms or a mix of the two. An example would be the statement: “this sea otter ate that crab”. (e.g., TODO cite fisheries diet databases).

!(n-ary)[https://raw.githubusercontent.com/jhpoelen/globis-b-interactions/master/figures/n-ary.png]

An n-ary interaction describes 2 or more taxa or individual organisms that interact with each other as part of a process. An example of this is a statement like: “this mosquito is a vector of a Plasmodium falciparum.  P. Falciparum is a pathogen of humans. The mosquito feeds on the blood of humans.” By grouping the various interactions, a process can be described, in this case a malaria infection of humans via mosquitos. (e.g., cite crop diseases, seed dispersal datasets)

!(network)[https://raw.githubusercontent.com/jhpoelen/globis-b-interactions/master/figures/network.png]

Similarly, a network interaction data model captures a complete description of all interactions in a specific community of interacting species (i.e. taxon-level) for a specific localized niche and interaction type (e.g., cite specific a pollinator network dataset). 

Pairwise, n-ary, and network models often use binary absence/presence or ternary (positive/none/negative) measures for each of the possible combinations of the participating species. In other cases, more continuous measures like a relative frequency of occurrence or percentage of diet are used to capture the strength of the interaction between participating taxa (e.g., Avian Diet Database).

In reality, studies often use a mix of the various data models to express the kind of data elements needed to answer specific research questions. For instance, DAPSTOM, a fish diet database, can be interpreted as a trophic network model of commercial fish in the North Sea, as well as pairwise interactions between commercial fish and their stomach content, or even an n-ary interaction that described the “eating” process of a specific fish specimen and the n-1 diets items found in its stomach. Also, the kind of interacting units vary from a general taxon level description (e.g., some cat-like species (Felidae) eat birds) to a specific statement like: “this mountain lion ate that deer” , or a mix of them, like: “this Atlantic Cod ate an arthropod”. 

A flexible data model to capture the pairwise, n-ary and network models can be constructed by non-exclusive grouping and nesting of pairwise-wise interactions (reference Dalmas et al. 2018, https://doi.org/10.1111/brv.12433). These pairwise interaction building blocks describe a directional interaction type (e.g., pathogen-host). At each end of the directional interaction, a source and target is identified. This source and target describes the interacting organisms.  The interactions can then be grouped as a process (vector-pathogen-host), by time/location/study (a specific pollinator network constructed by scientists xyz from data obtained at a specific place in time), or spatial domain (a specific group of diet items found in the stomach of a fish). Also, other qualities associated with the interaction (e.g., bibliograph reference, measurement method, evidence type, specimen identifier) can be added. A simplified version of this general model is used by GloBI (and mangal) to integrate the various kind of pairwise, n-ary and network models. 

!(network-as-pairwise.png)[https://raw.githubusercontent.com/jhpoelen/globis-b-interactions/master/figures/network-as-pairwise.png]


As an example, the figure above shows a traditional network model expressed in a collection of pairwise interactions. A similar exercise can be done for n-ary interactions as well as interaction that are associated with physical specimens, observation time, geospatial coordinates, bibiographic references and dataset provenance. 

Interaction Data Formats

The discussed interaction data models can be recorded, or expressed in, various ways. Before the digital era, natural language, tables and diagrams were used to record species interactions. In the digital era, digital representation of natural language (e.g., a digital file with Spanish text), tables (comma separated values text files, Excel spreadsheets) and diagrams (e.g., bitmap images, vector graphics) are still commonly used. In fact, natural language (aka free form text) and tables in digital form are still the dominant method to capture species interactions (see figure XX). A relatively recent 21st century development are structured text formats like JSON, XML, and RDF. While the nested, pair-wise interaction data model can be expressed in English (as evidenced in this text), tables, and diagrams, formats JSON, XML and RDF seem more suitable **for some** to intuitively capture the complexities of nested, or grouped pairwise interactions and their assocations.


For instance, a species interaction network can be expressed as pairwise interaction in table form using:

network id | source | interaction type | target
--- | --- | --- | ---
1 | sea urchin | eatenBy | sea otter
1 | sea otter | huntedBy | humans
… | … | … | …

However, a more intuitive format for some, particularly web developers, may be:

```json
“network” : { 
  “id” : 1
  “pairs” : [ 
	{ “source” : “sea urchin”, “interactionType” : “eatenBy”, “target” : “sea otter” },
	{ “source” : “sea urchin”, “interactionType” : “huntedBy”, “target” : “humans” }
  ]
}
```

where the any of the terms (e.g., source, target) may even consist of a nested structure describing the properties of the sea urchin like the taxonomic classification, location, lifestage and body size. 

For a more formal description, the flexible, yet precise, resource definition framework (RDF, https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/) can be used in combination with existing ontologies and controlled terms. A relatively “simple” example looks something like:

```
@prefix this: <http://purl.org/np/RAzquSkwsTAZm61nReG6MOjXEXUx8fNVfdWnAzyn6sOhU> .
@prefix sub: <http://purl.org/np/RAzquSkwsTAZm61nReG6MOjXEXUx8fNVfdWnAzyn6sOhU#> .
@prefix np: <http://www.nanopub.org/nschema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix prov: <http://www.w3.org/ns/prov#> .
@prefix pav: <http://swan.mindinformatics.org/ontologies/1.2/pav/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix obo: <http://purl.obolibrary.org/obo/> .

sub:Head {
  this: np:hasAssertion sub:Assertion ;
    np:hasProvenance sub:Provenance ;
    np:hasPublicationInfo sub:Pubinfo ;
    a np:Nanopublication . 
}

sub:Assertion {
  sub:Interaction obo:BFO_0000066 obo:ENVO_01000240 ;
    obo:RO_0000057 sub:Organism_1 , sub:Organism_2 ;
    a obo:GO_0044419 ;
    prov:atTime "1962-12-01T00:00:00Z"^^xsd:dateTime . 
  sub:Organism_1 obo:RO_0002470 sub:Organism_2 ;
    rdfs:label "Picoides villosus" . 
  sub:Organism_2 a <http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=114936> ;
    rdfs:label "Ips" . 
}

sub:Provenance {
  sub:Assertion prov:wasDerivedFrom sub:Study . 
  sub:Study dcterms:bibliographicCitation "Otvos, I. S. and R. W. Stark. 1985. Arthropod food of some forest-inhabiting birds. Canadian Entomologist 117:971-990." . 
}

sub:Pubinfo {
  this: dcterms:license <https://creativecommons.org/licenses/by/4.0/> ;
    pav:createdBy <https://doi.org/10.5281/zenodo.1212599> ;
    prov:wasDerivedFrom <https://github.com/hurlbertlab/dietdatabase> . 
  <https://github.com/hurlbertlab/dietdatabase> dcterms:bibliographicCitation "Allen Hurlbert. 2017. Avian Diet Database." . 
}
```

example from http://purl.org/np/RAzquSkwsTAZm61nReG6MOjXEXUx8fNVfdWnAzyn6sOhU via https://arxiv.org/pdf/1809.06532 .

As you can see, unlike tabular formats, the RDF format is not designed for widespread common day use by humans. However, the format is machine readable and allows for flexible, yet clearly defined, data modeling and data integration.

As the examples above show, information structured in an aggregate pair-wise interaction model can be expressed in many different data formats, without losing too much of the information or structure. When attempting to combine many different species interaction datasets, care should be taken to adopt file formats that cater to the community that will work with the data. While it is tempting to choose settle on one specific file format, the reality is that many data formats should be used to cover all the possible use cases. This is the reason why many projects, including GloBI, offer various data formats: tsv/csv archives for scientists and data analysts, rdf/nquads for semantic web enthousiasts, darwin core archives for biodiversity aggregator infrastructures, neo4j data dumps for software engineers and JSON fragments for web developers. 

Similarly, different researchers express their datasets in various format. As can be seen in table XX, many single-table, multi-table, darwin core archives, rdf and json is used to capture species interaction data. The wide spread adaption of spreadsheet applications in the research community, makes tabular data formats an intuitive choice for researchers to capture species interaction data. A recent article by Poisot et al. (review article by Dalmas et al. 2018, https://doi.org/10.1111/brv.12433) also suggested that interactions should be captured in pair-wise interactions to allow for flexible data modeling. In addition, many (references) argue that existing ontologies and term dictionaries should be used to clearly define the constructs and terms used in species interaction datasets. So, without have to repeat the many details on proposed best practices for biodiversity data (see Alex Hardisty manifesto), and realizing that adoption of standards in a scattered community is a gradual process, the following best practices are proposed for the publication of species interaction datasets:

0. first and foremost, try to re-use the data models, data formats and datasets of your colleagues.
1. use the aggregate pair-wise interactions data model to organize your data
2. use text based formats in UTF-8 encoding
3. review and adopt existing data formats before inventing your own. 
4. review and adopt existing ontologies and term dictionaries before inventing your own
5. use a data format that you can read, edit and write with a text editor. In addition, adopt powertools when convenient. Note a spreadsheet application is not a text editor, more like a powertool.
6. publicly register a preliminary dataset with existing infrastructures like GBIF, GloBI, Mangal or EBV-based processing pipelines as early as possible.
7. engage in discussions in existing workshops, conferences and professional societies on how to better structure your research data for re-use.
8. treat the datasets you produce and use just like you would a research paper 
