import { Component, OnInit, Output } from '@angular/core';
import { User }    from '../user';


@Component({
  selector: 'app-user-form',
  templateUrl: './user-form.component.html',
  styleUrls: ['./user-form.component.css']
})
export class UserFormComponent {

	model = 0;
	@Output() user;

	submitted = false;

	onSubmit() { this.submitted = true; }

	newUser() {
		this.user = new User(this.model, 'test');
	}
}
