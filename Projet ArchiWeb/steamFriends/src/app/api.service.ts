import { Injectable } from '@angular/core';
import { environment } from 'environments/environment';
import { Http, Response } from '@angular/http';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import {HttpResponse } from '@angular/common/http';
import { Subject } from "rxjs/Subject";

import 'rxjs/add/operator/map';

@Injectable()
export class ApiService {

	private apiUrl = 'http://api.steampowered.com/';
	private address = '163.172.161.181'

	constructor(private http : HttpClient){}

	public getName(obs : Subject<any>,user : number,index : number){
		this.http.get(`http://${this.address}:3000/getplayersummary/?${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next({'res' :res.body.response.players[0], 'index' : index});
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
		};

	public getUserStats(obs : Subject<any>,user : number, game : number){
		this.http.get(`http://${this.address}:3000/getuserstats/?${game}=${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next(res.body);
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};

	public getPlayerProfile(obs : Subject<any>,user : number){
		this.http.get(`http://${this.address}:3000/getplayersummary/?${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next(res.body);
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};

	public getFriendList(obs : Subject<any>,user : number){
		this.http.get(`http://${this.address}:3000/getfriendlist/?${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next(res.body);
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};

	public getOwnedGames(obs : Subject<any>,user : number){
		this.http.get(`http://${this.address}:3000/getownedgames/?${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next(res.body);
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};

	public filterFriendGame(obs : Subject<any>,user : number, game : number, index : number){
		this.http.get(`http://${this.address}:3000/filterfriendgame/?${game}=${user}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next({'res' :res.body.response, 'index' : index});
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};

	public getGameInfo(obs : Subject<any>,appid : number, index : number){
		this.http.get(`http://${this.address}:3000/getschema/?${appid}`,{ observe: 'response' })
		.subscribe(
			(res : any) => {
				obs.next({'res' : res.body, 'index' : index});
			},
			error => {
				alert("Error API not working");
				obs.next(null);
			}
		);
	};
}
