/**
 * @fileOverview This file has functions related to board user actions view. This view calling from board user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user model
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * CardSearchResult View
 * @class CardSearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.BoardUserActionsView = Backbone.View.extend({
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-view-user-activities': 'showUserActivitiesListModal',
        'click .js-show-dropdown': 'showDropdown',
        'click .js-no-action': 'noAction',
        'click .js-edit-board-member-permission-to-admin': 'editBoardMemberPermissionToAdmin',
        'click .js-edit-board-member-permission-to-normal': 'editBoardMemberPermissionToNormal',
        'click .js-close-popup': 'closePopup',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.is_admin = options.is_admin;
        this.render();
    },
    template: JST['templates/board_user_actions'],
    tagName: 'ul',
    className: 'list-unstyled',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var is_admin;
        if (this.model !== null && this.model.collection !== null && this.model.collection.models !== null) {
            for (i = 0; i < this.model.collection.models.length; i++) {
                if (this.model.collection.models[i].attributes.user_id == authuser.user.id) {
                    is_admin = (this.model.collection.models[i].attributes.is_admin === true || this.model.collection.models[i].attributes.is_admin === 't') ? true : false;
                }
            }
        }
        this.$el.html(this.template({
            user: this.model,
            is_admin: is_admin
        }));
        this.showTooltip();
        return this;
    },
    /**
     * showUserActivitiesListModal()
     * display list attachments
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showUserActivitiesListModal: function(e) {
        var user_id = $(e.currentTarget).data('user-id');
        var modalView = new App.ModalUserActivitiesListView({
            model: this.model,
            user_id: user_id
        });
        modalView.show();
        return false;
    },
    /**
     * showDropdown()
     * show Dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showDropdown: function(e) {
        e.preventDefault();
        $(e.currentTarget).parents('.dropdown:first').addClass('open');
        return false;
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * editBoardMemberPermissionToAdmin()
     * change board member permission to admin
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editBoardMemberPermissionToAdmin: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        this.model.url = api_url + 'boards_users/' + this.model.attributes.id + '.json';
        this.model.set('is_admin', true);
        this.model.save({
            is_admin: true
        }, {
            success: function(model, response) {

            }
        });

        return false;
    },
    /**
     * editBoardMemberPermissionToNoraml()
     * change board member permission to noraml
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editBoardMemberPermissionToNormal: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        this.model.url = api_url + 'boards_users/' + this.model.attributes.id + '.json';
        this.model.set('is_admin', false);
        this.model.save({
            is_admin: false
        }, {
            success: function(model, response) {

            }
        });

        return false;
    },
    /**
     * boardRename()
     * close the dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('div.dropdown:first, li.dropdown:first').removeClass('open');
        return false;
    }
});
