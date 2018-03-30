/**
 * @fileOverview This file has functions related to show all visibility view. This view calling from board add view, board header view and board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: visibility(String).
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * InviteUser View
 * @class InviteUserView
 * @constructor
 * @extends Backbone.View
 */
App.InviteUserView = Backbone.View.extend({
    tagName: 'li',
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
    template: JST['templates/invite_user'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit #InviteUserForm': 'inviteNewUser',
        'blur .js-invite-user-email': 'showInfo',
        'keydown .js-invite-user-email': 'clearInfo',
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
            board: this.model,
        }));
        $('.js-filter-parent').addClass('open');
        this.showTooltip();
        return this;
    },
    /**
     * clearInfo()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    clearInfo: function(e) {
        var target = $(e.target);
        $(target).closest('form').find('.js-invite-user-info').html('');
        $(target).closest('form').find('.js-invite-user-info-block').removeClass('show').addClass('hide');
    },
    /**
     * showInfo()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    showInfo: function(e) {
        e.preventDefault();
        var target = $(e.target);
        var email = $(e.currentTarget).val();
        var nameMatch = email.match(/^([^@]*)@/);
        var name = nameMatch ? nameMatch[1] : null;
        var nameParts = name.split(".");
        var fullname = nameParts[0].charAt(0).toUpperCase() + nameParts[0].slice(1);
        if (nameParts.length > 1) {
            var fullname = nameParts[0].toUpperCase() + ' ' + nameParts[1].charAt(0).toUpperCase() + nameParts[1].slice(1);
        }
        $(target).closest('form').find('.js-invite-user-fullname').val(fullname);
        $(target).closest('form').find('.js-invite-user-info').html('');
        $(target).closest('form').find('.js-invite-user-info').html('<strong>' + email + '</strong>? We don\'t know that person. Add a name and click "Send" and we’ll add a virtual member and send them an invite email. They\'ll automatically receive access to the board once they sign up and confirm their email address.');
        $(target).closest('form').find('.js-invite-user-info-block').removeClass('hide').addClass('show');

        return false;
    },
    /**
     * inviteNewUser()
     * invite new user
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    inviteNewUser: function(e) {
        var self = this;
        if (!$.trim($('#inputUserName').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputUserName');
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var target = $(e.target);
            var data = target.serializeObject();
            data.board_id = self.model.attributes.id;
            data.board_name = self.model.attributes.name;
            var self = this;
            var user = new App.User();
            user.url = api_url + 'users/invite.json';
            user.save(data, {
                success: function(model, response) {
                    if (response.error) {
                        self.flash('danger', i18next.t('Email address already exist. Your invite process is not completed. Please, try again.'));
                        target[0].reset();
                        target.find('.js-invite-user-info').html('');
                        target.find('.js-invite-user-info-block').removeClass('show').addClass('hide');
                    } else {
                        self.flash('success', i18next.t('User invited successfully.'));
                        target[0].reset();
                    }
                }
            });
        }
        return false;
    },
});
