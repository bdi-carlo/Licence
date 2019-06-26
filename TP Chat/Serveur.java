import java.io.IOException;
import java.net.InetAddress;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

import java.util.List;
import java.util.ArrayList;

public class Serveur {

	private ServerSocket serveur = null;
	private boolean continuer = true;
	private int port = 5000;
	private int backlog = 100;
	private String adresse = "127.0.0.1";
	private ClientProcesseur tabClients[];
	private List<Socket> lSocket;
	private int nbClients;

	//Création du serveur
	public Serveur(){
		try {
			//port, backlog, addresse
			serveur = new ServerSocket( port, backlog, InetAddress.getByName(adresse) );
			tabClients = new ClientProcesseur[10];
			lSocket = new ArrayList<Socket>();
			nbClients = 0;
		}catch( IOException e ){
			e.printStackTrace();
		}
	}

	public void ajouteClient( ClientProcesseur c, Socket s ){
		tabClients[nbClients] = c;
		lSocket.add(s);
		nbClients++;
	}

	public int getNbClients(){
		return nbClients;
	}

	//Lancement du serveur
	public void open() {
		Thread t = new Thread(new Runnable(){
			int count = 0;

			public void run(){
				while( continuer ){
					try {
						//Attente d'une connection client
						Socket client = serveur.accept();

						//System.out.println("Connection client-" + ++count);
						//On traite chaque nouvelle connection dans un nouveau Thread
						//ajouteClient(new ClientProcesseur(client), client);
						ClientProcesseur temp = new ClientProcesseur(client);
						Thread t = new Thread(temp);
						ajouteClient(temp, client);
						for( int i=0 ; i < nbClients ; i++ ){
							tabClients[i].majSock(lSocket, nbClients);
						}
						t.start();

					}catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		});
		t.start();
	}

	//Fermeture du serveur
	public void close(){
		continuer = true;
	}

}
