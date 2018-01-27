 hextodec(s) =                                                             \\ fonction qui convertie une chaine d'hexadecimal en un entier
    { my(v = Vecsmall(s), h = 0);                                          \\ Certaines coordonnées données par le NIST etait en hexa 
      for(i = 1, #v,
        h = (h<<4) + if(v[i]<=57, v[i]-48, if(v[i]<=70, v[i]-55, v[i]-87))
      );h;
    }
    
p=115792089210356248762697446949407573530086143415290314195533631308867097853951;       
n=115792089210356248762697446949407573529996955224135760342422259061068512044369;

\\l'equation de la courbe elliptique est de la forme y^2 = x^3 + ax + b

a=Mod(-3, p);
b=Mod(hextodec("5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b"), p);

\\ premier point de la courbe pour le generateur

P=Mod([hextodec("6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296"), hextodec("4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5")],p);

E=ellinit([0,0,0,a,b]);   \\ definition de la courbe elliptique

d=random(p-2)+2;          \\ on tire aleatoirement d entier tel que Q=d*P
Q=ellpow(E,P,d);          \\ On definit Q el deuxieme point de la courbe

Se=listcreate(2^16);      \\ Se est une liste servant a stocker la sortie du generateur
i=1;

\\s est la graine et a est le nombre de fois que l'on veut faire tourner le generateur

generateur(s, a)={
	
	local(P1,r,P2,s1,Q1,t);
	if(a==0, i=1; return(Se));
	
	P1=ellpow(E, P, s);
	
	r=lift(P1[1]);   \\r=x1(s*P)
	
	P2=ellpow(E, P,r);
	s1=lift(P2[1]);   \\s1=x1(r*P) avec s1 la graine pour le prochain tour de generateur
	
	Q1=ellpow(E, Q,r);
	t=lift(Q1[1]);	   \\t=x1(r*Q)
	b=t>>16;
	listinsert(Se, b, i); \\ on rajoute t decale de 16 bits a la liste de sortie
	i++;                   \\ increment du compteur pour la position de la liste
	generateur(s1, a-1);
}

\\d un entier tel que Q=d*P et alea est la sortie d'un tour du générateur

backdoor(d, alea)={
	local(S);
	S=[];
	W=bezout(d, n);
	e=lift(W[1]);      \\on commence par inverser d afin d'obtenir e tel que P=e*Q

	for(u=0, 2^16 -1,         \\pour tous les antécedents possibles de la sortie (2^16)
		x=(alea<<16)+u;;
		
		if((y=ellordinate(E,x))!=[],    \\ si il existe un point (x,y) sur la courbe E
			A=[x,y[1]];                 
			M=ellpow(E, A, e);          \\ on calcule M=e*A
			S=setunion(S, [lift(M[1])];) \\ on rajoute x1(M) a l'ensemble des graines possibles
		);
		
		);
	print("Ensemble de graine possible calcule \n");
	return(S);
		
}

\\ va trouver la graine du générateur
\\ G est l'ensemble de graine possible au tour i du générateur et sortie la sortie du générateur au tour i+1
 
testGraine(G, sortie)={

	for(u=1, length(G),                    \\pour toutes les graines possibles
		pseudosortie=generateur(G[u],1);    \\ on calcule la sortie avec les graines possibles
		if(pseudosortie[1]==sortie,          \\ si la sortie calcule vaut la sortie du générateur on a la bonne graine
			print("La graine suivante vaut " G[u] "\n");
			return(G[u]);
		);
	);
}
		
	

	
s=random(p-2)+2;	                                         \\on prend s graine aleatoire
print("La graine genere est: " s "\n");
alea=generateur(s, 10);     \\renvoie une liste de sortie 

print("Debut du calcul des differentes graines possibles\n");
print("\n");
G=backdoor(d,alea[1]);     \\ renvoie l'ensemble des graines possibles pour la sortie alea[1]

print("Debut du test des graines calcule\n");
s1=testGraine(G, alea[2]);

alea2=generateur(s1, 10);
print("          Nombre genere par le generateur                               |         Nombre genere par le generateur dont la graine a ete calcule\n");
for(j=1, 10, print(alea[j] " | " alea2[j] "\n"));

