/**
 * @fileOverview This file has functions related to archived card view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and it's related values. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ArchivedCard View
 * @class ArchivedCardView
 * @constructor
 * @extends Backbone.View
 */
App.ArchivedCardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        this.render();
    },
    template: JST['templates/archived_card'],
    tagName: 'li',
    className: 'list-group-item clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-archived-card': 'deleteArchivedCard',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model
                //board: this.model.list.collection.board
        }));
        this.showTooltip();
        return this;
    },
    /**
     * deleteArchivedCard()
     * delete archived card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteArchivedCard: function(e) {
        e.preventDefault();
        this.model.collection.remove([{
            id: this.model.attributes.id
        }]);
        this.$el.remove();
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.attributes.id + '.json';
        this.model.destroy();
        return false;
    },
});
