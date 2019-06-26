import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketException;
import java.util.Scanner;

import java.util.List;
import java.util.ArrayList;

public class ClientProcesseur implements Runnable{

	private Socket sock;
	private BufferedReader reader = null;
	private PrintWriter writer = null;
	private Scanner sc = new Scanner(System.in);
	private String nom;
	private List<Socket> lSocket;
	private int nbClients;

	public ClientProcesseur( Socket uneSock ){
		this.sock = uneSock;
		lSocket = new ArrayList<Socket>();
	}

	public String getName(){
		return nom;
	}

	public void majSock(  List<Socket> s, int nb ){
		lSocket = s;
		nbClients = nb;
	}

	public void run(){
		//Réception du pseudo
		try{

			reader = new BufferedReader(new InputStreamReader(sock.getInputStream()));
			writer = new PrintWriter(sock.getOutputStream());

			String message = read();
			InetSocketAddress remote = (InetSocketAddress)sock.getRemoteSocketAddress();

			this.nom = message;

			for( int i=0 ; i < nbClients; i++ ){
				Socket temp = lSocket.get(i);
				if( (temp != null && !temp.isClosed()) || temp != this.sock ){
					reader = new BufferedReader(new InputStreamReader(temp.getInputStream()));
					writer = new PrintWriter(temp.getOutputStream());

					writer.println(nom + " connecté");
					writer.flush();

					writer.println("> " + nom);
					writer.flush();
				}
			}

		}catch( IOException e ){
			//e.printStackTrace();
		}

		boolean close = false;
		while( !close ){

			try{

				reader = new BufferedReader(new InputStreamReader(sock.getInputStream()));
				writer = new PrintWriter(sock.getOutputStream());

				String message = read();
				InetSocketAddress remote = (InetSocketAddress)sock.getRemoteSocketAddress();

				if( message.equals("close") ){
					close = true;
				}
				if( close ){
					writer = null;
					reader = null;
					for( int i=0 ; i < nbClients; i++ ){
						Socket temp = lSocket.get(i);
						if( !temp.isClosed() ){
							reader = new BufferedReader(new InputStreamReader(temp.getInputStream()));
							writer = new PrintWriter(temp.getOutputStream());

							writer.println(nom + " deconnecté");
							writer.flush();
						}
					}

					//lSocket.remove(sock);
					sock.close();
					break;
				}

				else{
					//System.out.println(nom + ": " + message);
					//Envoie à tous les clients du nouveau message
					for( int i=0 ; i < nbClients; i++ ){
						Socket temp = lSocket.get(i);
						if( !temp.isClosed() ){
							reader = new BufferedReader(new InputStreamReader(temp.getInputStream()));
							writer = new PrintWriter(temp.getOutputStream());

							writer.println(nom + ": " + message);
							writer.flush();
						}
					}
				}

			}catch( IOException e ){
      			e.printStackTrace();
			}

		}
	}

	public String read() throws IOException{
		String message;
		message = reader.readLine();
		return message;
	}

}
