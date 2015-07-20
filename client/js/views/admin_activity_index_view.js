/**
 * @fileOverview This file has functions related to admin activity index view. This view calling from activity index view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity model and it's related values
 */
if (typeof App == 'undefined') {
    App = {};
}
App.AdminActivityIndexView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/admin_activity_index'],
    converter: new Showdown.converter(),
    tagName: 'li',
    className: 'row col-xs-12',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-undo2': 'undo_all'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var current_user_can_undo_it = false;
        if (!_.isUndefined(App.boards) && !_.isEmpty(this.model) && !_.isUndefined(this.model.attributes.board_id) && !_.isUndefined(App.boards.get(this.model.attributes.board_id))) {
            var board_users = App.boards.get(this.model.attributes.board_id).attributes.users;
            _.each(board_users, function(board_user) {
                if (parseInt(board_user.user_id) === parseInt(authuser.user.id) && board_user.is_admin === true) {
                    current_user_can_undo_it = true;
                }
            });
        }
        this.$el.html(this.template({
            activity: this.model,
            type: 'all',
            converter: this.converter,
            current_user_can_undo_it: current_user_can_undo_it
        }));
        this.$('.timeago').timeago();
    },
    /**
     * undo_all()
     * revert changes to the previous version
     * @param NULL
     * @return false
     */
    undo_all: function(e) {
        var self = this;
        e.preventDefault();
        this.model.url = api_url + 'activities/undo/' + this.model.id + '.json';
        this.model.save({}, {
            patch: true,
            success: function(model, response) {
                self.flash('danger', "Undo Succeed");
            }
        });
        return false;
    }
});
