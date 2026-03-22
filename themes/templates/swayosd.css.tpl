@define-color background-color {{ background }};
@define-color border-color {{ accent }};
@define-color label {{ foreground }};
@define-color image {{ foreground }};
@define-color progress {{ accent }};

window {
  border-radius: 0;
  opacity: 0.97;
  border: 2px solid @border-color;

  background-color: @background-color;
}

label {
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 11pt;

  color: @label;
}

image {
  color: @image;
}

progressbar {
  border-radius: 0;
}

progress {
  background-color: @progress;
}
