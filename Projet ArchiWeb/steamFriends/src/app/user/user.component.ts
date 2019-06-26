import { Component, OnInit, OnChanges, Input , SimpleChanges} from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import { User } from '../user';
import { ApiService } from '../api.service';
import { Observable } from 'rxjs/Observable';
import {HttpResponse } from '@angular/common/http';
import { Subject } from "rxjs/Subject";

import 'rxjs/add/operator/map';



@Component({
	selector: 'app-user',
	templateUrl: './user.component.html',
	styleUrls: ['./user.component.css']
})

export class UserComponent implements OnInit {
	private myData: any;
	private profile : any;
	private friends : any;
	private compareSelf : any;
	private compareOther : any;
	private games : any;
	private sortedGames : any ;
	private disabled :boolean = true;
	private filtered :boolean = false;
	private compared :boolean = false;
	private appList : any;

	@Input()
	user : User;

	constructor(private api : ApiService) {
		this.disabled = true;
	}

	private test(){
		let subject = new Subject<any>();
		let obs = subject.asObservable()

		console.log(this.user.steamId);
		this.api.getUserStats(subject,this.user.steamId,730);

		obs.subscribe((value) => {
			console.log("Subscription got", value);
			this.myData = value;
		});
	}

	private getFriendList(){
		let subject = new Subject<any>();
		let obs = subject.asObservable()

		this.api.getFriendList(subject,this.user.steamId);

		obs.subscribe((value) => {
			this.friends = value.friendslist.friends;


			for (var i = 0; i < this.friends.length; i++) {
				let subjectProfile = new Subject<any>();
				let obsProfile= subjectProfile.asObservable();

				this.api.getName(subjectProfile,this.friends[i].steamid,i);

				obsProfile.subscribe((value) => {
					this.friends[value.index].info = value.res;
				});
			}
		});
	}

	private filterFriendGame(gameID : number){
		let subjectProfile = new Subject<any>();
		let obsProfile= subjectProfile.asObservable();
		this.filtered = true;
		this.compared = false;


		for (var i = 0; i < this.friends.length; i++) {
			this.api.filterFriendGame(subjectProfile,this.friends[i].steamid,gameID,i);
			obsProfile.subscribe((value) => {
				this.friends[value.index].game = value.res;
			});
		}
	}

	private compareFriend(steamID : number, gameID : number){
		let subject1 = new Subject<any>();
		let obs1 = subject1.asObservable();

		let subject2 = new Subject<any>();
		let obs2 = subject2.asObservable();

		this.compared = true;
		this.filtered = false;

		console.log(steamID);
		console.log(gameID);


		this.api.getUserStats(subject1,this.user.steamId,gameID);

		this.api.getUserStats(subject2,steamID,gameID);

		obs1.subscribe((value) => {
			this.compareSelf = value;
		});

		obs2.subscribe((value) => {
			this.compareOther = value;
		});
	}

	private showProfile(){
		let subjectProfile = new Subject<any>();
		let obsProfile= subjectProfile.asObservable();

		//console.log(this.user);
		this.api.getPlayerProfile(subjectProfile,this.user.steamId);

		obsProfile.subscribe((value) => {
			//console.log("Subscription got", value);
			this.profile = value.response.players[0];
			if(this.profile != undefined){
				this.disabled = false;
			}
		});

		let subjectGames = new Subject<any>();
		let obsGames = subjectGames.asObservable();

		this.api.getOwnedGames(subjectGames,this.user.steamId);

		obsGames.subscribe((value) => {
			//console.log("Subscription got", value);
			this.games = value.response;
			this.sortedGames = this.filterByPlayTime();

		});
	}

	private padTime(t : number) {
		return t < 10 ? "0"+t : t;
	}

	private duration_for(snd : number) {
		if (typeof snd !== "number" || snd < 0)
			return "00:00:00";

			var hours = Math.floor(snd / 60),
			minutes = Math.floor((snd % 60) )

			return this.padTime(hours) + " hours : " + this.padTime(minutes) + " mins";
	}

	private filterByPlayTime(){
		var sortedArray = this.games.games;
		console.log(sortedArray);
		sortedArray.sort((a,b): any => b.playtime_forever - a.playtime_forever);
		sortedArray.length = 10;

		console.log(sortedArray);
		return sortedArray;
	}

	ngOnInit() {
	}

	ngOnChanges(changes : SimpleChanges){
		if (changes.user != undefined){
			if(changes.user.currentValue != undefined){
				this.profile = undefined;
				this.disabled = true;
				this.getFriendList();
				this.showProfile();
			}
		}
	}
}
