import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

import javax.swing.text.BadLocationException;

public class Client implements Runnable{

	private Socket clientSocket;
	private BufferedReader reader = null;
	private PrintWriter writer = null;
	private Scanner sc = new Scanner(System.in);//pour lire à partir du clavier
	private String nom;
	private Fenetre fen;
	private boolean running = true;
	private Thread recevoir;

	public Client( Fenetre fen, String name, String add, int port ){
		this.fen = fen;
		try{
			clientSocket = new Socket( add, port );
			this.nom = name;
			fen.cacheInfos();
		}catch( IOException e ){
			//e.printStackTrace();
			fen.msgAlerte( "Connetion impossible" );
		}
	}

	public PrintWriter getWriter(){
		return writer;
	}

	public void deconnexion() throws IOException{
		writer.println("close");
		writer.flush();
		running = false;
		if( clientSocket != null )
			clientSocket.close();
		reader = null;
		writer = null;
		System.exit(1);
	}

	public void run(){

		try{
			//flux pour envoyer
			writer = new PrintWriter(clientSocket.getOutputStream());
			//flux pour recevoir
			reader = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

			//Envoie du nom du client
			writer.println(nom);
			writer.flush();

			//Thread pour attendre des nouveaux messages
			recevoir = new Thread(new Runnable() {
				String reponse;
				@Override
				public void run() {
					while( running ){
						try {
							reponse = reader.readLine();
							while(reponse!=null){
								if( reponse.startsWith("> ") ){
									fen.ajouteNew(reponse);
								}
								else{
									try{
										fen.sDiscussion.insertString(fen.sDiscussion.getLength(), reponse + "\n", fen.defaut);
									}catch( BadLocationException e ){};
								}
								reponse = reader.readLine();
							}
							try{
								fen.sDiscussion.insertString(fen.sDiscussion.getLength(), "Vous êtes déconecté\n", fen.defaut);
							}catch( BadLocationException e ){}
							if( writer != null)
								writer.close();
							clientSocket.close();
						} catch (IOException e) {
							//e.printStackTrace();
						}
					}
				}
			});
			recevoir.start();

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main( String args[] ){
		Fenetre fen = new Fenetre();
	}

}
