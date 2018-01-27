
 hextodec(s) =
    { my(v = Vecsmall(s), h = 0);
      for(i = 1, #v,
        h = (h<<4) + if(v[i]<=57, v[i]-48, if(v[i]<=70, v[i]-55, v[i]-87))
      );h;
    }
    
p=115792089210356248762697446949407573530086143415290314195533631308867097853951;
n=115792089210356248762697446949407573529996955224135760342422259061068512044369;
a=Mod(-3, p);
b=Mod(hextodec("5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b"), p);

P=Mod([hextodec("6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296"), hextodec("4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5")],p);
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
			print("La graine vaut " G[u] "\n");
			return;
		);
	);
}
		
	

	
s=random(p-2)+2;	
print("graine a trouver : " s "\n");
alea=generateur(s, 2);     \\renvoie une liste de sortie 


G=backdoor(d,alea[1]);     \\ renvoie l'ensemble des graines possibles pour la sortie alea[1]
testGraine(G, alea[2]);





