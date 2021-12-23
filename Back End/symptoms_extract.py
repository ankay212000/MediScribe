import spacy
import pickle
import Levenshtein as lev

nlp = spacy.load('en_core_web_sm')
with open("symptoms_list.blob", "rb") as fp:  
    symptoms_list = pickle.load(fp)
  
def fuzzy_linear_search(text):
  symp_set = set()
  lis_text = text.split(" ")
  for i in range(1, 4):
    for j in range(len(lis_text)):
      word = " ".join(lis_text[j:j+i])
      j = j+i-2;
      for k in symptoms_list:
        ratio = lev.ratio(k.lower(), word.lower())
        if(ratio > 0.90):
          symp_set.add(k)

  return symp_set

def general_extractor(text):
  text = text.upper()
  symptoms=[]
  doc = nlp(text)
  
  bigram=[]
  token=[]

  for to in doc:
    token.append((to.pos_,to.text));

  for i in range(1,len(doc)):
    bigram.append([(doc[i-1].pos_,doc[i-1].text),(doc[i].pos_,doc[i].text)])

  for symp in bigram:
    temp=""
    if(symp[0][0]=="NOUN" and symp[1][0]=="NOUN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="ADJ" and symp[1][0]=="NOUN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="ADJ" and symp[1][0]=="PROPN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="PROPN" and symp[1][0]=="PROPN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="VERB" and symp[1][0]=="PROPN"):      
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="VERB" and symp[1][0]=="NOUN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="PROPN" and symp[1][0]=="NOUN"):
      temp+=symp[0][1]+" "+symp[1][1]
    elif(symp[0][0]=="NOUN" and symp[1][0]=="PROPN"):
      temp+=symp[0][1]+" "+symp[1][1]  

    if(len(temp)>0):
      symptoms.append(temp)    

  for symp in token:
    if(symp[0]=="NOUN" or symp[0]=="PROPN"):
      flag=True
      for selected in symptoms:
        if(symp[1] in selected):
          flag=False
          break
      if(flag):
        symptoms.append(symp[1])

  return symptoms

# text = "A VERY HIGH FEVER WITH STOMACH ACHE AND BLOOD VOMITING AT NIGHT ALSO HAD SEVERE HEADACHE"
# print(general_extractor(text))

def extract_symptoms(st):
    text = st.upper()

    output = dict()

    # Getting symptoms from both methods 
    fuzzy_set = fuzzy_linear_search(text.strip())
    pos_list = general_extractor(text.strip())
    fuzzy_list = list(fuzzy_set)

    # keeping the longer symptom in the fuzzy method output list if overlap
    for i in fuzzy_list:
      for j in fuzzy_list:
        if(i in j and i!=j):
          if i in fuzzy_set : fuzzy_set.remove(i)
    fuzzy_list = list(fuzzy_set)
  
    # Giving priority to the symptoms found from the fuzzy search method
    output_set = set(pos_list + fuzzy_list)
    for pos in pos_list:
      for fuz in fuzzy_list:
        if(pos in fuz) or (fuz in pos):
          if(pos in output_set): output_set.remove(pos)
          output_set.add(fuz)

    output["symptoms"] = list(output_set)
    return output

# print(extract_symptoms("I am feeling headache with running nose and body pain "))
# print(extract_symptoms("I have fever and running nose and headache and flaking skin and insomnia"))
# text = "I have flaking skin, stomach ulcer, high fever and loss of appetite"
# print(extract_symptoms(text))


