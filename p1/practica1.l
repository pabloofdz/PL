%{
unsigned charCount = 0, otherWords = 0, uppercaseWords = 0, lowercaseWords = 0, numericWords = 0, sentenceCount = 0;
%}
word          [^ \t\n.]+
uppercaseWord [A-ZÁÉÍÓÚÑ]+
lowercaseWord [a-záéíóúñ]+
numericWord   [0-9]+
delim         [ \t\n]
ws            {delim}+
%%
{ws}               { /* ignore white space */ }
\.                 {charCount++;}
{uppercaseWord}\.  {uppercaseWords++; sentenceCount++; charCount += yyleng;}
{lowercaseWord}\.  {lowercaseWords++; sentenceCount++; charCount += yyleng;}
{numericWord}\.    {numericWords++; sentenceCount++; charCount += yyleng;}
{word}\.           {otherWords++; sentenceCount++; charCount += yyleng;}
{uppercaseWord}    {uppercaseWords++; charCount += yyleng;}
{lowercaseWord}    {lowercaseWords++; charCount += yyleng;}
{numericWord}      {numericWords++; charCount += yyleng;}
{word}             {otherWords++; charCount += yyleng;}
%%
int main()
{
	yylex();
	
	printf("\nCaracteres: %d\n", charCount);
	printf("Palabras totales: %d\n", uppercaseWords + lowercaseWords + numericWords + otherWords);
	printf("Palabras en mayúscula: %d\n", uppercaseWords);
	printf("Palabras en minúscula: %d\n", lowercaseWords);
	printf("Palabras numéricas: %d\n", numericWords);
	printf("Otras palabras: %d\n", otherWords);
	printf("Frases: %d\n", sentenceCount);
	return 0;
}
