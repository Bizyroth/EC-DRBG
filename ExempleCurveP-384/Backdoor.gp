 hextodec(s) =
    { my(v = Vecsmall(s), h = 0);
      for(i = 1, #v,
        h = (h<<4) + if(v[i]<=57, v[i]-48, if(v[i]<=70, v[i]-55, v[i]-87))
      );h;
    }
    
p=39402006196394479212279040100143613805079739270465446667948293404245721771496870329047266088258938001861606973112319;
n=39402006196394479212279040100143613805079739270465446667946905279627659399113263569398956308152294913554433653942643;
a=Mod(-3, p);
b=Mod(hextodec("b3312fa7e23ee7e4988e056be3f82d19181d9c6efe8141120314088f5013875ac656398d8a2ed19d2a85c8edd3ec2aef"), p);

P=Mod([hextodec("aa87ca22be8b05378eb1c71ef320ad746e1d3b628ba79b9859f741e082542a385502f25dbf55296c3a545e3872760ab7"), hextodec("3617de4a96262c6f5d9e98bf9292dc29f8f41dbd289a147ce9da3113b5f0b8c00a60b1ce1d7e819d7a431d7c90ea0e5f")],p);
E=ellinit([0,0,0,a,b]);

d=random(p-2)+2;
Q=ellpow(E,P,d);

Se=listcreate(2^16);
i=1;

generateur(s, a)={
	
	local(P1,r,P2,s1,Q1,t);
	if(a==0, i=1; return(Se));
	
	P1=ellpow(E, P, s);
	
	r=lift(P1[1]);
	
	P2=ellpow(E, P,r);
	s1=lift(P2[1]);
	
	Q1=ellpow(E, Q,r);
	t=lift(Q1[1]);	
	b=t>>16;
	listinsert(Se, b, i);
	i++;
	generateur(s1, a-1);
}



backdoor(d, alea)={
	local(S);
	S=[];
	W=bezout(d, n);
	e=lift(W[1]);

	for(u=0, 2^16 -1,
		x=(alea<<16)+u;;
		
		if((y=ellordinate(E,x))!=[],
			A=[x,y[1]]; 
			M=ellpow(E, A, e); 
			S=setunion(S, [lift(M[1])];)
		);
		
		);
	print("Ensemble de graine possible calcule \n");
	return(S);
		
}

testGraine(G, sortie)={

	for(u=1, length(G),
		pseudosortie=generateur(G[u],1);
		if(pseudosortie[1]==sortie, 
			print("La graine suivante vaut " G[u] "\n");
			return(G[u]);
		);
	);
}
		
	

	
s=random(p-2)+2;	
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

