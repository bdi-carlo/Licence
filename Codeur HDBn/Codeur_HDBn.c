#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define L 100

/*int message(int sequence[L]){ /* Fonction qui permet de rentrer la sequence que l'on veut */
	/*int temp;
	int i = 0;

	system("clear");
	
	printf("Rentrer votre chaine qui fini par 2: ");

	do{
		do{
			scanf("%i",&temp);
			
			if(temp != 1 && temp != 0 && temp != -1 && temp != 2)
				printf("Veuiller rentrer unniquement des 1, des 0 ou des -1: ");
				
		}while(temp != 1 && temp != 0 && temp != -1 && temp != 2);
		
		if(temp != 2){
			sequence[i] = temp;
			i++;
		}

	}while(temp != 2 && i != L);
	
	return i;
}*/

void affichage(int sequence[L], int S[L], int longueur, int type){
	int i = 0;

	system("clear");

	/* Affichage pour l'encodage */
	if(type == 1){
		printf("\nSequence a encoder: ");
		for(i = 0; i < longueur; i++)
			printf("%i ",sequence[i]);
		
		printf("\nSequence encodee:   ");
		for(i = 0; i < longueur; i++)
				printf("%i ",S[i]);
		
		printf("\nAffichage courbe: ");
		for(i = 0; i < longueur; i++){
			if(S[i] == -1)
				printf("↓");
			if(S[i] == 1)
				printf("↑");
			if(S[i] == 0)
				printf("-");
		}
	}

	/* Affichage pour le decodage */
	if(type == 2){
		printf("\nSequence a decoder: ");
		for(i = 0; i < longueur; i++)
			printf("%i ",sequence[i]);
		
		printf("\nSequence decodee:   ");
		for(i = 0; i < longueur; i++)
				printf("%i ",S[i]);
	}
	
	printf("\n\nAppuyer sur entrer");
	getchar();
	getchar();
}

void encodage(int sequence[L]){
	int P[L];			/* Tableau correspondant au positifs */
	int N[L];			/* Tableau correspondant au negatifs */
	int S[L];			/* S = P-1*N */
	
	int i, premier_zero;
	int suite_zero = 0;	/* Nombre de zero à la suite */
	int type_HDB = 3;	/* Par default HDB3 */
	int viol = -1;		/* Viol initialisé à V- */
	int last_one = 1;	/* Dernier 1 initialisé à +1 */

	/* Recuperation de la sequence et de sa longueur */
	/* int longueur = message(sequence); */
	int longueur = 23;

	/* Demande le type d'encodage */
	do{
		printf("\nChoix HDB: ");
		scanf("%i",&type_HDB);
	}while(type_HDB < 2);

	/* Encodage */
	for(i = 0; i < longueur; i++){
		if(sequence[i] == 1 && i == 0){	/* Premier 1 rencontré */
			P[i] = 1;
			N[i] = 0;
		}
		
		else if(sequence[i] == 0){	/* Cas ou on recontre un zero */
			suite_zero++;
			P[i] = 0;
			N[i] = 0;
		}
			
		else{					/* Si un 1 est rencontré ailleurs dans la séquence */
			suite_zero = 0;
			
			if(last_one == 1){	/* Cas ou viol = V+ */
				last_one = -1;
				P[i] = 0;
				N[i] = 1;
			}
			
			else if(last_one == -1){	/* Cas ou viol = V- */
				last_one = 1;
				P[i] = 1;
				N[i] = 0;
			}
		}
			
		if(suite_zero == type_HDB+1){	/* Vérification du nombre de zero correspondant au HDB */
			premier_zero = i - type_HDB;
			if(viol == -1){	/* Premier cas si viol = V- */
				if(last_one == -1){
					P[premier_zero] = 1;
					P[i] = 1;
					last_one = 1;
				}
				else{
					P[i] = 1;
					last_one = 1;
				}
				viol = 1;
			}
			else if(viol == 1){	/* Deuxième cas si viol = V+ */
				if(last_one == -1){
					N[i] = 1;
					last_one = -1;
				}
				else{
					N[premier_zero] = 1;
					N[i] = 1;
					last_one = -1;
				}
				viol = -1;
			}
			suite_zero = 0;
		}	
	}
	
	for(i = 0; i < longueur; i++){
		S[i] = P[i] - 1 * N[i];
	}
	
	affichage(sequence, S, longueur, 1);
}

void decodage(int sequence[L]){
	int S[L];			/* Sequence de sortie */

	int i, j;
	int type_HDB = 3;	/* Par default HDB3 */
	int verif;		/* Permettra de verifier une condition plus tard */
	int viol = -1;		/* Viol initialisé à V- */
	int last_one = 1;	/* Dernier 1 initialisé à +1 */

	/* Recuperation de la sequence et de sa longueur */
	/* int longueur = message(sequence); */
	int longueur = 23;

	/* Recuperation du type de codage */
	do{
		printf("\nVeuiller rentrer le type de codage: HDB: ");
		scanf("%i", &type_HDB);
	}while(type_HDB < 2);
	
	/* Decodage */
	for(i = 0; i < longueur; i++){
		if(sequence[i] == 0)
			S[i] = 0;

		else if(sequence[i] == -1){
			/* Rencontre de la sequence -1 0 -1 */
			if(sequence[i+type_HDB] == -1 && last_one == 1 && viol == 1){
				verif = 1;
				/* Boucle permettant de vérifier si on rentre dans le cas de l'agorithme de notre type de codage */
				for(j = i+1; j < i+type_HDB; j++){
					if(sequence[j] != 0)
						verif = 0;
				}
				if(verif == 1){ /* Si V+ et +1 alors 0 0 0 */
					for(j = i; j <= i+type_HDB; j++)
						S[j] = 0;
					i = i + type_HDB;
					viol = -1;
				}
				else
					S[i] = 1;
			}
			/*****/
			else if(i == 1){	/* Deuxieme rencontré */
				S[i] = 1;
			}
			/*****/
			/* Rencontre de la sequence 0 0 -1 */
			else if(sequence[i-type_HDB] == 0 && last_one == -1 && viol == 1){
				verif = 1;
				/* Boucle permettant de vérifier si on rentre dans le cas de l'agorithme de notre type de codage */
				for(j = i-type_HDB; j < i; j++){
					if(sequence[j] != 0)
						verif = 0;
				}
				if(verif == 1){
					S[i] = 0;
					viol = -1;
				}
				else
					S[i] = 1;
			}
			/*****/
			else
				S[i] = 1;

			last_one = -1;
		}

		else if(sequence[i] == 1){
			/* Rencontre de la sequence 1 0 1 */
			if(sequence[i+type_HDB] == 1 && last_one == -1 && viol == -1){
				verif = 1;
				for(j = i+1; j < i+type_HDB; j++){
					if(sequence[j] != 0)
						verif = 0;
				}
				if(verif == 1){
					for(j = i; j <= i+type_HDB; j++)
						S[j] = 0;
					i = i + type_HDB;
					viol = -1;
				}
				else
					S[i] = 1;
			}
			/*****/
			else if(i == 0){	/* Premier 1 rencontré */
				S[i] = 1;
			}
			/*****/
			/* Rencontre de la sequence 0 0 1 */
			else if(sequence[i-type_HDB] == 0 && last_one == 1 && viol == -1){
				verif = 1;
				for(j = i-type_HDB; j < i; j++){
					if(sequence[j] != 0)
						verif = 0;
				}
				if(verif == 1){
					S[i] = 0;
					viol = 1;
				}
				else
					S[i] = 1;
			}
			/*****/
			else
				S[i] = 1;

			last_one = 1;
		}
	}

	affichage(sequence, S, longueur, 2);
}

int main(){
	int sequence_a_encoder[L] = {1,0,0,1,0,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0};
	int sequence_a_decoder[L] = {1,0,0,-1,0,1,0,0,1,-1,0,-1,1,-1,1,0,1,0,-1,1,-1,0,0};

/******* Demande à l'utilisateur ce qu'il veut faire ******/

	int choix;
	
	do{	/* Affichage du menu */
		system("clear");

		printf("\n+--------------------------------+ ");
		printf("\n|    Encodeur / Decodeur HDBn    |");
		printf("\n|                                |");
		printf("\n|         1 - Encoder            |");
		printf("\n|         2 - Decoder            |");
		printf("\n|         3 - Quitter            |");
		printf("\n|                                |");
		printf("\n+--------------------------------+ ");
	
		do{
			printf("\n>> Votre choix : ");
			scanf("%d",&choix);

			/* Traitement du choix de l'utilisateur */
			switch(choix){	
				case 1: encodage(sequence_a_encoder); break;
				case 2: decodage(sequence_a_decoder); break;
				case 3: break;
				default: printf("\nErreur: votre choix doit etre compris entre 1 et 4\n");
				}
		}while(choix < 1 || choix > 3);
	}while(choix != 3);
	
	printf("\nBye !\n");
}
