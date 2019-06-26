import java.awt.*;
import javax.swing.*;
import javax.swing.text.*;
import javax.swing.text.BadLocationException;
import java.awt.event.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Fenetre extends JFrame implements ActionListener{

	//Eviter les problèmes de sérialisation
	static final long serialVersionUID = -1234567890123456789L;

	private JButton bConnection;
	private JButton bEnvoyer;
	private JTextField tNom;
	private JTextField tIP;
	private JTextField tPort;
	public JTextPane tDiscussion;
	public StyledDocument sDiscussion;
	private JTextArea tMessage;
	private JTextArea tConnectes;
	private Client client = null;
	private boolean connecte = false;
	public Style defaut;

  Fenetre(){
		setTitle("New MSN");
		setSize(700, 700);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		addWindowListener( new CustomWindowListener() );

		getContentPane().add(panNorth(), BorderLayout.NORTH);
		getContentPane().add(panWest(), BorderLayout.WEST);
		getContentPane().add(panCenter(), BorderLayout.CENTER);

		this.getRootPane().setBorder(BorderFactory.createEmptyBorder(10,10,10,10));

		setVisible(true);
  }

	//Getters
	public String getNom(){
		return tNom.getText();
	}

	public String getIP(){
		return tIP.getText();
	}

	public int getPort(){
		if( tPort.getText() == null )
			return 0;

		return Integer.parseInt(tPort.getText());
	}

	public String getMessage(){
		return tMessage.getText();
	}

	//Création du panel du Nord de la fenetre
	private JPanel panNorth(){
		JPanel pan = new JPanel();

		//Création d'un GridLayout de 2 colonne et 2 lignes
		GridLayout gl = new GridLayout(3,2);
		gl.setHgap(100); //100 pixels d'espace entre les colonnes (H comme Horizontal)
		gl.setVgap(10); //10 pixels d'espace entre les lignes (V comme Vertical)
		pan.setLayout(gl);

		JLabel lNom = new JLabel("Nom");
		tNom = new JTextField(20);
		Box hNom = Box.createHorizontalBox();
		hNom.add(lNom);
		hNom.add(tNom);
		pan.add(hNom);

		bConnection = new JButton("Connection");
		bConnection.addActionListener(this);
		bConnection.setEnabled(true);
		pan.add(bConnection);

		JLabel lIP = new JLabel("IP");
		tIP = new JTextField(5);
		tIP.setText("127.0.0.1");
		Box hIP = Box.createHorizontalBox();
		hIP.add(lIP);
		hIP.add(tIP);
		pan.add(hIP);

		JLabel lPort = new JLabel("Port");
		tPort = new JTextField(20);
		tPort.setText("5000");
		Box hPort = Box.createHorizontalBox();
		hPort.add(lPort);
		hPort.add(tPort);
		pan.add(hPort);

		//pan.setBorder(BorderFactory.createEmptyBorder(3,3,3,3));
		return pan;
	}

	//Méthode qui permet de mettre à jour l'utilisation du bouton Connection
	public void setConnectionEnable(boolean b){
		bConnection.setEnabled(b);
	}

	//Création du panel du Centre de la fenetre
	private JPanel panCenter(){
		JPanel pan = new JPanel();

		BoxLayout b = new BoxLayout(pan, BoxLayout.PAGE_AXIS);
		//GridBagLayout b = new GridBagLayout();
		pan.setLayout(b);

		//Création du texte area discussion avec son label
		JLabel lDiscussion = new JLabel("Discussion");
		tDiscussion = new JTextPane();
		defaut = tDiscussion.getStyle("default");
		sDiscussion = (StyledDocument)tDiscussion.getDocument();
		tDiscussion.setEnabled(false);
		pan.add(lDiscussion);
		pan.add(tDiscussion);

		//Création du texte area message avec son label
		JLabel lMessage = new JLabel("Message");
		tMessage = new JTextArea();
		JScrollPane sMessage = new JScrollPane(tMessage);
		tMessage.setEnabled(false);
		pan.add(lMessage);
		pan.add(sMessage);

		//Création du bouton envoyer
		bEnvoyer = new JButton("Envoyer");
		bEnvoyer.addActionListener(this);
		bEnvoyer.setEnabled(false);
		pan.add(bEnvoyer);

		pan.setBorder(BorderFactory.createEmptyBorder(3,3,3,3));
		return pan;
	}

	//Création du panel de l'Ouest de la fenetre
	private JPanel panWest(){
		JPanel pan = new JPanel();

		BoxLayout b = new BoxLayout(pan, BoxLayout.PAGE_AXIS);
		pan.setLayout(b);

		//Créaton du tableau de users
		//String tabUsers[] = { "user1" , "user2" };

		//Création du texte area discussion avec son label
		JLabel lConnectes = new JLabel("Connectes");
		tConnectes = new JTextArea();
		tConnectes.setEnabled(false);

		pan.add(lConnectes);
		pan.add(tConnectes);

		pan.setPreferredSize(new Dimension(getHeight()/3, getWidth()));

		pan.setBorder(BorderFactory.createEmptyBorder(3,3,3,10));
		return pan;
	}

	public void setEnabledTextFielsTo( boolean b ){
		tNom.setEnabled(b);
		tIP.setEnabled(b);
		tPort.setEnabled(b);
	}

	//Création d'un message d'alerte
	public void msgAlerte( String s ){
  	JOptionPane.showMessageDialog( null, s, "Erreur", JOptionPane.ERROR_MESSAGE);
 	}

	//Cache les infos après Connection
	public void cacheInfos(){
		try{
			sDiscussion.insertString(sDiscussion.getLength(),"Connection au serveur " + getIP() + " réussie\n", defaut);
		}catch( BadLocationException e ){}
		tNom.setText(null);
		setEnabledTextFielsTo(false);
		bConnection.setText("Deconnection");
		connecte = true;

		tDiscussion.setEnabled(true);
		tMessage.setEnabled(true);
		bEnvoyer.setEnabled(true);
	}

	public void ajouteNew( String n ){
		tConnectes.append(n + "\n");
	}

	//Traite les événements des différents boutons de la fenetre
	public void actionPerformed( ActionEvent event ){
		Object source = event.getSource();

		if( source == bConnection ){
			if( connecte ){
				try{
					client.deconnexion();
				}catch( IOException e ){
					e.printStackTrace();
				}
				tDiscussion.setText(null);
				tConnectes.setText(null);
				setEnabledTextFielsTo(true);
				bConnection.setText("Connection");
			}
			else{
				Thread t = new Thread(client=new Client(this, getNom(), getIP(), getPort()));
				t.start();
			}
		}

		else if( source == bEnvoyer ){
			String message = getMessage();
			client.getWriter().println(message);
			client.getWriter().flush();

			tMessage.setText(null);
			System.out.println("Envoyer");
		}
	}

	private class CustomWindowListener extends WindowAdapter{
		public void windowClosing( WindowEvent e ){
			if( client != null ){
				try{
					client.deconnexion();
				}catch( IOException f ){
					f.printStackTrace();
				}
			}
			System.exit(1);
		}
	}

}
