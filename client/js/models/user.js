if (typeof App === 'undefined') {
    App = {};
}
/**
 * User Model
 * @class User
 * @constructor
 * @extends Backbone.Model
 */
App.User = Backbone.Model.extend({
    initialize: function(args) {
        this.activities = new App.ActivityCollection();
        this.activities.url = api_url + 'users/' + this.id + '/activities.json';

        this.cards = new App.CardUserCollection();
        this.cards.url = api_url + 'users/' + this.id + '/cards.json';

        this.boards_stars = new App.BoardStarCollection();

        this.boards_users = new App.BoardsUserCollection();

        this.organizations = new App.OrganizationCollection();
    }
});
